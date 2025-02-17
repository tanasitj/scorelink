﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;
using System.Web.UI;
using Scorelink.BO.Helper;
using Scorelink.MO;
using Scorelink.MO.DataModel;

namespace Scorelink.BO.Repositories
{
    public class DocumentDetailRepo : Interface.IDocumentDetail<DocumentDetailModel>
    {
        public DocumentDetailModel Get(int id)
        {
            ScorelinkEntities db = new ScorelinkEntities();
            try
            {
                var data = (from doc in db.DocumentDetails
                        where doc.DocId == id && doc.ScanStatus != "Y"
                        select new DocumentDetailModel
                        {
                            DocDetId = doc.DocDetId,
                            DocId = doc.DocId,
                            DocPageNo = doc.DocPageNo,
                            FootnoteNo = doc.FootnoteNo,
                            PageType = doc.PageType,
                            ScanStatus = doc.ScanStatus,
                            PageFileName = doc.PageFileName,
                            PagePath = doc.PagePath,
                            PageUrl = doc.PageUrl,
                            Selected = doc.Selected,
                            PatternNo = doc.PatternNo,
                            CreateBy = doc.CreateBy,
                            CreateDate = doc.CreateDate.ToString(),
                            UpdateDate = doc.UpdateDate.ToString()
                        }).FirstOrDefault();

                return data;
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                throw ex;
            }
        }
        public IEnumerable<DocumentDetailModel> GetList(int id)
        {
            ScorelinkEntities db = new ScorelinkEntities();
            try
            {
                var query = (from doc in db.DocumentDetails
                             where doc.DocId == id
                             select new DocumentDetailModel
                             {
                                 DocDetId = doc.DocDetId,
                                 DocId = doc.DocId,
                                 DocPageNo = doc.DocPageNo,
                                 FootnoteNo = doc.FootnoteNo,
                                 PageType = doc.PageType,
                                 ScanStatus = doc.ScanStatus,
                                 PageFileName = doc.PageFileName,
                                 PagePath = doc.PagePath,
                                 PageUrl = doc.PageUrl,
                                 Selected = doc.Selected,
                                 PatternNo = doc.PatternNo,
                                 CreateBy = doc.CreateBy,
                                 CreateDate = doc.CreateDate.ToString(),
                                 UpdateDate = doc.UpdateDate.ToString()
                             });
                return query;
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                throw ex;
            }
        }
        public IEnumerable<DocumentDetailModel> GetList(int id, string pageType)
        {
            ScorelinkEntities db = new ScorelinkEntities();
            try
            {
                var query = (from doc in db.DocumentDetails
                             where doc.DocId == id && doc.PageType == pageType
                             select new DocumentDetailModel
                             {
                                 DocDetId = doc.DocDetId,
                                 DocId = doc.DocId,
                                 DocPageNo = doc.DocPageNo,
                                 FootnoteNo = doc.FootnoteNo,
                                 PageType = doc.PageType,
                                 ScanStatus = doc.ScanStatus,
                                 PageFileName = doc.PageFileName,
                                 PagePath = doc.PagePath,
                                 PageUrl = doc.PageUrl,
                                 Selected = doc.Selected,
                                 PatternNo = doc.PatternNo,
                                 CreateBy = doc.CreateBy,
                                 CreateDate = doc.CreateDate.ToString(),
                                 UpdateDate = doc.UpdateDate.ToString()
                             });
                return query;
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                throw ex;
            }
        }
        public IEnumerable<DocumentDetailModel> GetListView(int id)
        {
            ScorelinkEntities db = new ScorelinkEntities();
            try
            {
                var query = (from doc in db.F_DocumentDetail(id)
                             where doc.DocId == id
                             select new DocumentDetailModel
                             {
                                 DocId = doc.DocId,
                                 DocPageNo = doc.PageNo,
                                 FootnoteNo = doc.FootnoteNo,
                                 PageType = doc.StatementId.ToString(),
                                 PageTypeName = doc.StatementName
                             });
                return query;
            }
            catch (Exception ex)
            {
                Logger Err = new Logger();
                Err.ErrorLog(ex.ToString());
                throw ex;
            }
        }
        public string Update(DocumentDetailModel item)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
            {
                using (System.Data.Entity.DbContextTransaction dbTran = db.Database.BeginTransaction())
                {
                    try
                    {
                        var docDet = db.DocumentDetails.Where(x => x.DocDetId == item.DocDetId).First();
                        docDet.DocId = item.DocId;
                        docDet.DocPageNo = item.DocPageNo;
                        docDet.FootnoteNo = item.FootnoteNo;
                        docDet.PageType = item.PageType;
                        docDet.ScanStatus = item.ScanStatus;
                        docDet.PageFileName = item.PageFileName;
                        docDet.PagePath = item.PagePath;
                        docDet.Selected = item.Selected;
                        docDet.PatternNo = item.PatternNo;
                        docDet.UpdateDate = DateTime.Parse(item.UpdateDate);

                        db.SaveChanges();
                        dbTran.Commit();

                        return "OK";
                    }
                    catch (Exception ex)
                    {
                        dbTran.Rollback();
                        Logger Err = new Logger();
                        Err.ErrorLog(ex.ToString());
                        return ex.ToString();
                    }
                }
            }
        }
        public string UpdateScanStatus(DocumentDetailModel item)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
            {
                using (System.Data.Entity.DbContextTransaction dbTran = db.Database.BeginTransaction())
                {
                    try
                    {
                        var docDet = db.DocumentDetails.Where(x => x.DocDetId == item.DocDetId).First();
                        docDet.ScanStatus = item.ScanStatus;
                        docDet.UpdateDate = DateTime.Parse(item.UpdateDate);

                        db.SaveChanges();
                        dbTran.Commit();

                        return "OK";
                    }
                    catch (Exception ex)
                    {
                        dbTran.Rollback();
                        Logger Err = new Logger();
                        Err.ErrorLog(ex.ToString());
                        return ex.ToString();
                    }
                }
            }
        }
        public string UpdatePatternNo(int docId, string pageType, string patternNo)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
            {
                using (System.Data.Entity.DbContextTransaction dbTran = db.Database.BeginTransaction())
                {
                    try
                    {
                        var docDet = db.DocumentDetails.Where(x => x.DocId == docId && x.PageType == pageType).ToList();

                        foreach (DocumentDetail det in docDet)
                        {
                            det.PatternNo = patternNo;
                            det.UpdateDate = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
                        }

                        db.SaveChanges();
                        dbTran.Commit();

                        return "OK";
                    }
                    catch (Exception ex)
                    {
                        dbTran.Rollback();
                        Logger Err = new Logger();
                        Err.ErrorLog(ex.ToString());
                        return ex.ToString();
                    }
                }
            }
        }
        public string Add(DocumentDetailModel item)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
            {
                using (System.Data.Entity.DbContextTransaction dbTran = db.Database.BeginTransaction())
                {
                    try
                    {
                        var doc = new DocumentDetail
                        {
                            //DocDetId = item.DocDetId,
                            DocId = item.DocId,
                            DocPageNo = item.DocPageNo,
                            FootnoteNo = item.FootnoteNo,
                            PageType = item.PageType,
                            ScanStatus = item.ScanStatus,
                            PageFileName = item.PageFileName,
                            PagePath = item.PagePath,
                            PageUrl = item.PageUrl,
                            Selected = item.Selected,
                            Commited = item.Commited,
                            PatternNo = item.PatternNo,
                            CreateBy = item.CreateBy,
                            CreateDate = DateTime.Parse(item.CreateDate),
                            UpdateDate = DateTime.Parse(item.UpdateDate)
                    };

                        db.DocumentDetails.Add(doc);
                        db.SaveChanges();

                        //var lastuser = db.Users.Select(x => x.UserId).Max();

                        dbTran.Commit();

                        return "OK";
                    }
                    catch (Exception ex)
                    {
                        dbTran.Rollback();
                        Logger Err = new Logger();
                        Err.ErrorLog(ex.ToString());
                        return ex.ToString();
                    }
                }
            }
        }
        public string Delete(string id)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
            {
                using (System.Data.Entity.DbContextTransaction dbTran = db.Database.BeginTransaction())
                {
                    try
                    {
                        var doc = db.DocumentDetails.Where(x => x.DocDetId.ToString() == id).First();
                        db.DocumentDetails.Remove(doc);

                        db.SaveChanges();
                        dbTran.Commit();

                        return "OK";
                    }
                    catch (Exception ex)
                    {
                        dbTran.Rollback();
                        Logger Err = new Logger();
                        Err.ErrorLog(ex.ToString());
                        return ex.ToString();
                    }
                }
            }
        }
        public string DeleteTypes(string docid,string pagetype,string docPageNo)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
            {
                using (System.Data.Entity.DbContextTransaction dbTran = db.Database.BeginTransaction())
                {
                    try
                    {
                        if (docPageNo == "0") // Delete All Pages
                        {
                            //-- Delete By Type Id --//
                            //Delete Document Area.
                            var area = db.DocumentAreas.Where(x => x.DocId.ToString() == docid && x.PageType.ToString() == pagetype);
                            db.DocumentAreas.RemoveRange(area);
                            //Delete Document Detail.
                            var doc = db.DocumentDetails.Where(x => x.DocId.ToString() == docid && x.PageType.ToString() == pagetype);
                            db.DocumentDetails.RemoveRange(doc);
                        }
                        else  
                        {
                            //-- Delete By Page No. --//
                            //Delete Document Area.
                            var area = db.DocumentAreas.Where(x => x.DocId.ToString() == docid && x.PageType.ToString() == pagetype && x.DocPageNo.ToString() == docPageNo);
                            db.DocumentAreas.RemoveRange(area);
                            //Delete Document Detail.
                            var doc = db.DocumentDetails.Where(x => x.DocId.ToString() == docid && x.PageType.ToString() == pagetype && x.DocPageNo.ToString() == docPageNo).First();
                            db.DocumentDetails.Remove(doc);
                        }                    
                        db.SaveChanges();
                        dbTran.Commit();
                        return "OK";
                    }
                    catch (Exception ex)
                    {
                        dbTran.Rollback();
                        Logger Err = new Logger();
                        Err.ErrorLog(ex.ToString());
                        return ex.ToString();
                    }
                }
            }
        }
        public string CommitedStatus(DocumentDetailModel item)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
            {
                using (System.Data.Entity.DbContextTransaction dbTran = db.Database.BeginTransaction())
                {
                    try
                    {
                        var docDet = db.DocumentDetails.Where(x => x.DocId == item.DocId && x.PageType == item.PageType).ToList();

                        foreach (DocumentDetail det in docDet)
                        {
                            det.Commited = "Y";
                            det.UpdateDate = DateTime.Parse(DateTime.Now.ToString("yyyy-MM-dd hh:mm:ss"));
                        }

                        db.SaveChanges();
                        dbTran.Commit();

                        return "OK";
                    }
                    catch (Exception ex)
                    {
                        dbTran.Rollback();
                        Logger Err = new Logger();
                        Err.ErrorLog(ex.ToString());
                        return ex.ToString();
                    }
                }
            }
        }
        public bool CheckCommited(int docId)
        {
            using (ScorelinkEntities db = new ScorelinkEntities())
                return db.DocumentDetails.Where(x => x.DocId == docId && x.Commited == "Y").Any();

        }
    }
}
