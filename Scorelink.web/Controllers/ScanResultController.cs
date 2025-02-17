﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using Scorelink.BO.Helper;
using Scorelink.MO.DataModel;
using Scorelink.BO.Repositories;
using System.IO;
using Spire.Xls;
//using OfficeOpenXml;
using System.Text.RegularExpressions;
using System.Text;
using System.Drawing;



namespace Scorelink.web.Controllers
{
    public class ScanResultController : Controller
    {
        // GET: ScanResult
        DocumentDetailRepo docDetailRepo = new DocumentDetailRepo();
        DocumentInfoRepo docInfoRepo = new DocumentInfoRepo();
        ResultModel objModel = new ResultModel();
        ScanEditRepo GetField = new ScanEditRepo();
        public ActionResult Index(int docId, int pageType, string pageTypeName)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("/Home/Index");
            }
            else
            {
                ViewBag.UserId = Session["UserId"].ToString();
                int iUserId = 0;
                Int32.TryParse(Session["UserId"].ToString(), out iUserId);

                //Get User Info.
                UserRepo userRepo = new UserRepo();
                var userDB = userRepo.Get(iUserId);
                ViewBag.Name = userDB.Name;
                ViewBag.Surname = userDB.Surname;

                //Check and Update online date time.
                OnlineUserRepo onlineRepo = new OnlineUserRepo();
                var online = onlineRepo.Get(iUserId);
                onlineRepo.Update(online);

                //Get Document Info data.
                var Info = GetField.GetInfo(docId);
                //Get Document Detail data.
                var Details = GetField.GetDetails(docId, pageType.ToString());
                string sPagePath = Consts.sUrl + "/FileUploads/" + Common.GenZero(Info.CreateBy, 8) + "/" + Info.FileUID + "/";
                var data = docInfoRepo.Get(docId);
                ViewBag.docId = data.DocId;
                ViewBag.PageFileName = data.FileName;
                ViewBag.PageUrl = sPagePath + "SL" + Common.GenZero(Details.PageType, 5) + ".tif";
                ViewBag.TempPath = sPagePath;
                ViewBag.PageType = pageType;
                ViewBag.PageTypeName = pageTypeName;
                ViewBag.PatternNo = Details.PatternNo;
                ViewBag.Language = Info.Language;
            }
            return View("ScanResult", objModel);
        }
        public List<DataResult> Grid_Row(int docId,string PageType)
        {
            DocumentInfoRepo docInfoRepo = new DocumentInfoRepo();
            AccountTitleRepo accGroupRepo = new AccountTitleRepo();

            var info = docInfoRepo.Get(docId);
            var details = GetField.GetDetails(docId, PageType);
            //=============================================================================
            String sSaveFolder = Server.MapPath("..\\FileUploads\\" + Common.GenZero(info.CreateBy, 8) + "\\" + info.FileUID + "\\" + "RST" + Common.GenZero(details.PageType, 5) + ".csv");
            var lines = System.IO.File.ReadAllLines(@sSaveFolder);
            List<DataResult> objTempmodel = new List<DataResult>();
            foreach (var line in lines)
            {
                Regex csv_file = new Regex(",(?=(?:[^\"]*\"[^\"]*\")*(?![^\"]*\"))");
                string[] words = csv_file.Split(line);
                var accTitle = accGroupRepo.GetAccountTitleId(words[0].Trim(new Char[] { '"' }));
                string accGrpId = "";
                if (accTitle == null)
                {
                    accGrpId = "";
                }
                else
                {
                    accGrpId = accTitle.AccGroupId.ToString();
                }

                if (details.PatternNo == "2")
                {
                    objTempmodel.Add(new DataResult
                    {
                        Footnote_No = words[1].Trim(new Char[] { '"' }),
                        Divisions = DivisionStatus(),
                        Digitized_Account_Title = words[0].Trim(new Char[] { '"' }),
                        AccountTitleGroupId = accGrpId,
                        Recovered = "",//RecoveredStatus(),
                        Standard_Title = "",
                        Amount1 = words[2].Trim(new Char[] { '"' }),
                        Amount2 = words[3].Trim(new Char[] { '"' }),
                        Modified = "",
                        CLCTCD = ""
                    }); ;
                }else if (details.PatternNo == "3")
                {
                    objTempmodel.Add(new DataResult
                    {
                        Footnote_No = words[1].Trim(new Char[] { '"' }),
                        Divisions = DivisionStatus(),
                        Digitized_Account_Title = words[0].Trim(new Char[] { '"' }),
                        AccountTitleGroupId = accGrpId,
                        Recovered = "",//RecoveredStatus(),
                        Standard_Title = "",
                        Amount1 = words[2].Trim(new Char[] { '"' }),
                        Amount2 = words[3].Trim(new Char[] { '"' }),
                        Amount3 = words[4].Trim(new Char[] { '"' }),
                        Modified = "",
                        CLCTCD = ""
                    });
                }
                else
                {
                    objTempmodel.Add(new DataResult
                    {
                        Footnote_No = words[1].Trim(new Char[] { '"' }),
                        Divisions = DivisionStatus(),
                        Digitized_Account_Title = words[0].Trim(new Char[] { '"' }),
                        AccountTitleGroupId = accGrpId,
                        Recovered = "",//RecoveredStatus(),
                        Standard_Title = "",
                        Amount1 = words[2].Trim(new Char[] { '"' }),
                        Modified = "",
                        CLCTCD = ""
                    });
                }
                
            }
            return objTempmodel;
        }     
        public JsonResult Commit_file(int docId,string pageType,string csv_file,string filenames)
        {
            try
            {
                var Info = docInfoRepo.Get(docId);
                //Get Document Detail data.
                String Folder_Path = Server.MapPath("..\\FileUploads\\" + Common.GenZero(Info.CreateBy, 8) + "\\" + Info.FileUID + "\\" + filenames);
                FileInfo files = new FileInfo(Folder_Path);
                using (var sw = new StreamWriter(files.ToString(), false, Encoding.UTF8))
                {
                    sw.WriteLine(csv_file);
                }
                DocumentDetailModel docDetail = new DocumentDetailModel();

                //Update DocumentDetail
                docDetail.DocId = docId;
                docDetail.PageType = pageType;
                docDetailRepo.CommitedStatus(docDetail);
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                return Json(ex.Message);
            }
            return Json("Success");
        }
        public JsonResult ExportAllResult(int docId)
        {
            var Info = docInfoRepo.Get(docId);
            //Get Document Detail data.
            String FolderPath = Server.MapPath("..\\FileUploads\\" + Common.GenZero(Info.CreateBy, 8) + "\\" + Info.FileUID + "\\");
            //String UrlPath = Common.getConstTxt("sUrl") + "/FileUploads/" + Common.GenZero(Info.CreateBy, 8) + "/" + Info.FileUID + "/";
            String UrlPath = "~/FileUploads/" + Common.GenZero(Info.CreateBy, 8) + "/" + Info.FileUID + "/";
            List<string> files = new List<string>();
            string Statement = FolderPath + "Tmp001.csv";
            string BalanceSheet = FolderPath + "Tmp002.csv";
            string Cashflow = FolderPath + "Tmp003.csv";
            //var fileName = "AllReSult" + ".xlsx";
            string sDateTime = DateTime.Now.ToString("yyyyMMddHHmmssFFFF");
            var UserFileName = "ARS" + Info.FileUID + ".xlsx";
            var TmpFileName = "EX" + sDateTime + ".xlsx";

            //Check File for insert parameter
            try
            {
                if (System.IO.File.Exists(Statement))
                {
                    files.Add(@"Tmp001");
                }
                if (System.IO.File.Exists(BalanceSheet))
                {
                    files.Add(@"Tmp002");
                }
                if (System.IO.File.Exists(Cashflow))
                {
                    files.Add(@"Tmp003");
                }
                //Call Procedure create file
                if (files.Count > 0)
                {
                    Create_Temp_Files(files, FolderPath);
                    //CombineFiles(files, FolderPath, UrlPath);

                    //Save the file to server temp folder
                    //string fullPath = Path.Combine(Server.MapPath("~/temp"), fileName);
                    string TmpPath = Path.Combine(Server.MapPath(UrlPath), TmpFileName);

                    Workbook newbook = new Workbook();
                    newbook.Version = ExcelVersion.Version2013;
                    newbook.Worksheets.Clear();
                    Workbook tempbook = new Workbook();
                    if (files.Count > 0)
                    {
                        for (int i = 0; i < files.Count; i++)
                        {
                            tempbook.LoadFromFile(FolderPath + files[i] + ".xlsx");
                            foreach (Worksheet sheet in tempbook.Worksheets)
                            {
                                newbook.Worksheets.AddCopy(sheet);
                            }
                        }
                        //create file to save on server
                        //newbook.SaveToFile(FolderPath + "AllReSult.xlsx", ExcelVersion.Version2013);
                        newbook.SaveToFile(FolderPath + UserFileName, ExcelVersion.Version2013);
                        //create file to folder temp for client download
                        newbook.SaveToFile(TmpPath, ExcelVersion.Version2013);

                    }

                }
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                return Json(ex.Message);
            }
            //return Json(new { fileName = fileName });
            //return Json("Success");
            return Json(TmpFileName);
        }
        public ActionResult Download(string file, int docId)
        {
            //Get the temp folder and file path in server
            try
            {
                var Info = docInfoRepo.Get(docId);
                String UrlPath = "~/FileUploads/" + Common.GenZero(Info.CreateBy, 8) + "/" + Info.FileUID + "/";

                string fullPath = Path.Combine(Server.MapPath(UrlPath), file);
                byte[] fileByteArray = System.IO.File.ReadAllBytes(fullPath);
                System.IO.File.Delete(fullPath);
                return File(fileByteArray, "application/vnd.ms-excel", file);
            }
            catch (Exception ex)
            {
                return Json(ex.Message);
            }
        }
        public JsonResult SeeAllResult(int docId)
        {
            var Info = docInfoRepo.Get(docId);
            String FolderPath = Server.MapPath("..\\FileUploads\\" + Common.GenZero(Info.CreateBy, 8) + "\\" + Info.FileUID + "\\");
            //string fullPath = Path.Combine(Server.MapPath("~/temp"));
            try
            {
                System.Diagnostics.Process.Start(FolderPath + "AllReSult.xlsx");
                //System.Diagnostics.Process.Start(fullPath + "AllReSult.xlsx"); //path temp file
            }
            catch (Exception ex)
            {
                return Json(ex.Message);
            }
            return Json("Success");
        }
        public void Create_Temp_Files(List<string> files,string FolderPath)
        {
            Workbook newbook = new Workbook();
            newbook.Version = ExcelVersion.Version2013;
            newbook.Worksheets.Clear();
            Workbook workbook = new Workbook();
            if (files.Count > 0)
            {
                for (int i = 0; i < files.Count; i++)
                {
                    workbook.LoadFromFile(FolderPath + files[i].ToString() + ".csv", ",", 1, 1);
                    Worksheet sheet = workbook.Worksheets[0];
                    int last = sheet.LastRow;
                    sheet.Name = files[i].ToString();
                    switch (sheet.Name)
                    {
                        case "Tmp001": { sheet.Name = "Income Statement"; break; }
                        case "Tmp002": { sheet.Name = "Balance Sheet"; break; }
                        case "Tmp003": { sheet.Name = "Cash flow"; break; }
                    }

                    sheet.Range["C2:E" + last].Style.Color = Color.Gold;
                    sheet.Range["C2:E" + last].Style.Font.FontName = "Segoe UI";
                    sheet.Range["C2:E" + last].Style.Font.Size = 11.5;
                    sheet.Range["C1" + sheet.LastColumn].Style.Font.IsBold = true;
                    sheet.SetColumnWidth(2, 15);
                    sheet.SetColumnWidth(3, 30);
                    sheet.SetColumnWidth(4, 30);
                    sheet.SetColumnWidth(5, 30);
                    sheet.SetColumnWidth(6, 20);
                    workbook.SaveToFile(FolderPath.ToString() + files[i].ToString() + ".xlsx", ExcelVersion.Version2010);
                }
            }
        }
        public void CombineFiles(List<string> files,string FolderPath,string UrlPath)
        {
            Workbook newbook = new Workbook();
            newbook.Version = ExcelVersion.Version2013;
            newbook.Worksheets.Clear();
            Workbook tempbook = new Workbook();
            if (files.Count > 0)
            {
                for (int i = 0; i < files.Count; i++)
                {
                    tempbook.LoadFromFile(FolderPath + files[i] + ".xlsx");
                    foreach (Worksheet sheet in tempbook.Worksheets)
                    {
                        newbook.Worksheets.AddCopy(sheet);
                    }
                }
                newbook.SaveToFile(FolderPath + "AllReSult.xlsx", ExcelVersion.Version2013);
            }
           
        }
        public SelectList DivisionStatus()
        {
            List<Status> status = new List<Status>();
            status.Add(new Status { ID = 1, StatusName = "Major" });
            status.Add(new Status { ID = 2, StatusName = "Major1" });
            status.Add(new Status { ID = 3, StatusName = "Major2" });
            status.Add(new Status { ID = 4, StatusName = "Major3" });
            SelectList objinfo = new SelectList(status, "ID", "StatusName");
            return objinfo;
        }
        public SelectList RecoveredStatus()
        {
            List<Status> status = new List<Status>();
            status.Add(new Status { ID = 1, StatusName = "direct costs" });
            status.Add(new Status { ID = 2, StatusName = "cash and bank balance" });
            status.Add(new Status { ID = 3, StatusName = "gain on investment" });
            status.Add(new Status { ID = 4, StatusName = "increase in other receivables" });
            status.Add(new Status { ID = 5, StatusName = "state subsidy" });
            status.Add(new Status { ID = 6, StatusName = "indent sales" });
            status.Add(new Status { ID = 7, StatusName = "other direct costs" });
            status.Add(new Status { ID = 8, StatusName = "purchases" });
            status.Add(new Status { ID = 9, StatusName = "investment income" });
            status.Add(new Status { ID = 10, StatusName = "-other plant and equipment" });
            status.Add(new Status { ID = 11, StatusName = "financial asset" });
            SelectList objinfo = new SelectList(status, "ID", "StatusName");
            return objinfo;
        }
        public JsonResult AssignGrid(int docId,string PageType)
        {
            checkOnline();
            objModel.ScanEdit = Grid_Row(docId,PageType);
            var resultobject = objModel.ScanEdit.ToList();
            return Json(resultobject,JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetAccountTitleGroupDD(string sLanguage)
        {
            checkOnline();
            AccountTitleGroupRepo accGroupRepo = new AccountTitleGroupRepo();
            var data = accGroupRepo.GetAccountTitleGroupDD(sLanguage);
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public AccountTitleModel GetAccountTitleId(string stxt)
        {
            checkOnline();
            AccountTitleRepo accGroupRepo = new AccountTitleRepo();
            var data = accGroupRepo.GetAccountTitleId(stxt);
            return data;
        }
        public JsonResult GetFormulaList(string userId,FormulaModel item)
        {
            checkOnline();
            FormulaRepo formulaRepo = new FormulaRepo();
            var data = formulaRepo.GetFormulaList(userId,item).ToList();
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult GetFormulaResult(string userId, string sQuery)
        {
            checkOnline();
            FormulaRepo formulaRepo = new FormulaRepo();
            var data = formulaRepo.GetFormulaResult(userId, sQuery);
            return Json(data, JsonRequestBehavior.AllowGet);
        }
        public JsonResult SummaryScore(SummaryScoreModel[] item)
        {
            var result = "";
            SummaryScoreRepo sumRepo = new SummaryScoreRepo();
            SummaryScoreModel sumMO = new SummaryScoreModel();

            try
            {
                checkOnline();
                //Clear Old Data
                sumRepo.Delete(item[0].CreateBy);
                //Loop Object
                for (int i = 0; i < item.Length; i++)
                {
                    if (item[i].AccGroupId != 0)
                    {
                        //Set Value
                        sumMO.CreateBy = item[i].CreateBy;
                        sumMO.AccGroupId = item[i].AccGroupId;
                        sumMO.SumAmount1 = (item[i].SumAmount1 ?? "0").Replace(",", "");
                        sumMO.SumAmount2 = (item[i].SumAmount2 ?? "0").Replace(",", "");
                        sumMO.SumAmount3 = (item[i].SumAmount3 ?? "0").Replace(",", "");

                        if (sumRepo.CheckExist(sumMO)) {
                            sumRepo.Update(sumMO);
                        }
                        else
                        {
                            sumRepo.Add(sumMO);
                        }
                    }
                }
                result = "OK";
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                return Json(ex.Message);
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        private void checkOnline()
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("/Home/Index");
            }
            else
            {
                ViewBag.UserId = Session["UserId"].ToString();
                int iUserId = 0;
                Int32.TryParse(Session["UserId"].ToString(), out iUserId);

                //Get User Info.
                UserRepo userRepo = new UserRepo();
                var userDB = userRepo.Get(iUserId);
                ViewBag.Name = userDB.Name;
                ViewBag.Surname = userDB.Surname;

                //Check and Update online date time.
                OnlineUserRepo onlineRepo = new OnlineUserRepo();
                var online = onlineRepo.Get(iUserId);
                onlineRepo.Update(online);
            }
        }
    }
}