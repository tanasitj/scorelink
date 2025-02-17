﻿using System;
using System.Management;
using System.Net;
using System.Web.Mvc;
using Scorelink.BO.Helper;
using Scorelink.BO.Repositories;
using Scorelink.MO.DataModel;

namespace Scorelink.web.Controllers
{
    public class HomeController : Controller
    {
        
        public ActionResult Index()
        {
            ViewBag.IP = GetIPAddress();
            ViewBag.CPU = GetCPUID();
            ViewBag.Session = Session.SessionID;
            return View("Login");
        }

        [HttpGet]
        public ActionResult AnotherLink()
        {
            return View("Index");
        }

        public ActionResult Register()
        {
            return View("Register");
        }

        public JsonResult Login(string user, string pass, OnlineUserModel online)
        {
            string result = "";
            UserRepo userRepo = new UserRepo();
            OnlineUserRepo onlineRepo = new OnlineUserRepo();

            userRepo.UpdateExpireUser();

            //Check User
            if (userRepo.CheckLogIn(user, Common.EncryptText(pass)))
            {
                var userDB = userRepo.Get(user);
                online.UserId = userDB.UserId;

                //Check Online User
                if (onlineRepo.CheckTimeOut(online))
                {
                    //If User Timeout
                    result = "Time";
                }
                else
                {
                    //onlineRepo.Update(online);
                    Session["UserId"] = userDB.UserId;
                    Session["Name"] = userDB.Name;
                    Session["Surname"] = userDB.Surname;
                    Session["Email"] = userDB.Email;
                    Session["Company"] = userDB.Company;
                    Session["Address"] = userDB.Address;
                    Session["Telephone"] = userDB.Telephone;
                    Session["RegisterDate"] = userDB.RegisterDate;
                    Session["ExpireDate"] = userDB.ExpireDate;

                    result = "Ok";
                }
            }
            else
            {
                //User not found or Password Incorrect.
                result = "NO";
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Logout(int userid)
        {
            OnlineUserRepo onlineRepo = new OnlineUserRepo();
            onlineRepo.Delete(userid);

            ViewBag.IP = GetIPAddress();
            ViewBag.CPU = GetCPUID();
            ViewBag.Session = Session.SessionID;

            Session.Clear();
            Session.Abandon();
            return View("Login");
        }

        public ActionResult ForgotPassword()
        {
            return View("ForgotPassword");
        }

        public JsonResult SaveRegister(UserModel item)
        {
            try
            {
                var data = "";
                UserRepo userRepo = new UserRepo();

                if (userRepo.CheckUserDup(item.UserName))
                {
                    //Duplicate Username
                    data = "Dup";
                }
                else
                {
                    item.Status = "N";
                    item.Admin = "N";
                    item.UpdateBy = "System";
                    data = userRepo.Add(item);
                }

                return Json(data, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                return Json(ex.Message);
            }
        }

        public static string GetIPAddress()
        {
            string IPAddress = "";


            IPHostEntry Host = default(IPHostEntry);
            string Hostname = null;
            Hostname = System.Environment.MachineName;
            Host = Dns.GetHostEntry(Hostname);
            foreach (IPAddress IP in Host.AddressList)
            {
                if (IP.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                {
                    IPAddress =  IP.ToString();
                }
            }

            return IPAddress;
        }

        //Get MAC Address
        public static string GetMACAddress()
        {
            string sMac = "";

            using (var mc = new ManagementClass("Win32_NetworkAdapterConfiguration"))
            {
                foreach (ManagementObject mo in mc.GetInstances())
                {
                    sMac = mo["MacAddress"].ToString();
                }

                return sMac;
            }
        }

        public static string GetCPUID()
        {
            var mbs = new ManagementObjectSearcher("Select ProcessorId From Win32_processor");
            ManagementObjectCollection mbsList = mbs.Get();
            string id = "";
            foreach (ManagementObject mo in mbsList)
            {
                id = mo["ProcessorId"].ToString();
                break;
            }

            return id;
        }

        public JsonResult GetMenuList(int userId)
        {
            UserRepo userRepo = new UserRepo();
            var user = userRepo.Get(userId);

            var txt = "";
            if (user.Status == "Y")
            {
                if (user.Admin == "Y")
                {
                    txt += "" +
                        //" <li class='nav-header'> Admin Menu</li> " +
                        " <li class='nav-item'> " +
                        " <a href='/User/Index' class='nav-link'> " +
                        " <i class='nav-icon fas fa-users'></i> " +
                        " <p>User List</p> " +
                        " </a> " +
                        " </li> " +
                        " <li class='nav-item'> " +
                        " <a href = '/Company/Index' class='nav-link'> " +
                        " <i class= 'nav-icon fas fa-building'></i> " +
                        " <p>Company List</p> " +
                        " </a> " +
                        " <li class='nav-item'> " +
                        " <a href = '/Upload/Index' class='nav-link'> " +
                        " <i class='nav-icon fas fa-file-pdf'></i> " +
                        " <p>Scorelink</p> " +
                        " </a> " +
                        " </li> ";
                }
                else if (userRepo.CheckExpireDate(userId))
                {
                    txt += "" +
                        //" <li class='nav-header'>User Menu</li> " +
                        " <li class='nav-item'> " +
                        " <a href = '/Upload/Index' class='nav-link'> " +
                        " <i class='nav-icon fas fa-file-pdf'></i> " +
                        " <p>Scorelink</p> " +
                        " </a> " +
                        " </li> ";
                }
            }

            /*txt += " <li class='nav-item'> " +
                    " <a href='#log_out' id='alogout' class='nav-link'> " +
                    " <i class='nav-icon fas fa-sign-out-alt'></i> " +
                    " <p>Logout</p> " +
                    " </a> " +
                    " </li> ";*/

            return Json(txt, JsonRequestBehavior.AllowGet);
        }
    }
}
