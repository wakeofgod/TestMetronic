using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TestMetronic.A2ZModel
{
    public class LM_T_NCRs_Detail:BaseModel
    {
        [Display(Name = "CAR acceptance leadtime")]
        public int? CARAcceptanceLeadtime { get; set; }
        [Display(Name = "Search Lot Number")]
        [MaxLength(128)]
        public string SearchLogNo { get; set; }
        [Display(Name = "Proposed Rejection Type")]
        public int? ProposedRejectionType { get; set; }
        [Display(Name = "Raised by Area/VS")]
        [MaxLength(128)]
        public string RaisedbyAreaVS { get; set; }
        [Display(Name = "Liability")]
        [MaxLength(128)]
        public string Liability { get; set; }
        [Display(Name = "RCA Type")]
        public int? RCAType { get; set; }
        [Display(Name = "Quantity Reworked")]
        public int? QuantityReworked { get; set; }
        [Display(Name = "Quantity Scrapped")]
        public int? QuantityScrapped { get; set; }
        [Display(Name = "Balanket Number")]
        [MaxLength(128)]
        public string BalanketNo { get; set; }
        [Display(Name = "Lot Number")]
        [MaxLength(128)]
        public string LotNo { get; set; }
        [Display(Name = "QN(if applicable)")]
        [MaxLength(128)]
        public string QN { get; set; }
        [Display(Name = "Raised by")]
        [MaxLength(128)]
        public string RaisedBy { get; set; }
        [Display(Name = "CEC item Muber")]
        [MaxLength(128)]
        public string CECItemNo { get; set; }
        [Display(Name = "RMA(Return Material Authorizition)")]
        [MaxLength(128)]
        public string ReturnMA { get; set; }
        [Display(Name = "Where Found")]
        [MaxLength(128)]
        public string WhereFound { get; set; }
        [Display(Name = "Category")]
        [MaxLength(128)]
        public string Category { get; set; }
        [Display(Name = "What is the required specification?")]
        [MaxLength(500)]
        public string Whatistherequired { get; set; }
        [Display(Name = "What is the specification?")]
        [MaxLength(500)]
        public string WhatistheSpecification { get; set; }
        [Display(Name = "Current/Revision/Issue Number")]
        [MaxLength(500)]
        public string CurrentRINo { get; set; }
        [Display(Name = "Was this issue caused by a sub-tier supplier?")]
        [MaxLength(128)]
        public string WasthisICBASS { get; set; }
        [Display(Name = "Please provide supplier")]
        [MaxLength(128)]
        public string PleaseProvideSupplier { get; set; }
        [Display(Name = "Other")]
        [MaxLength(128)]
        public string Other { get; set; }
        [Display(Name = "Is this a")]
        public int? IsthisType { get; set; }
        [Display(Name = "Parent RCA")]
        [MaxLength(128)]
        public string ParentRCA { get; set; }
        [Display(Name = "Certification of Conformity Number")]
        [MaxLength(128)]
        public string CertificateofCFNo { get; set; }
        [Display(Name = "Impact Area")]
        [MaxLength(128)]
        public string DFImpactArea { get; set; }
        [DataType(DataType.Date)]
        [Display(Name = "Submitted Date")]
        public DateTime? FRSubmittedDate { get; set; }
        [DataType(DataType.Date)]
        [Display(Name = "Submitted Date")]
        public DateTime? CASubmittedDate { get; set; }
        [Required]
        public Guid Info { get; set; }
        [Display(Name = "Site")]
        [MaxLength(128)]
        public string Site { get; set; }
        [Display(Name = "Site NCR/SRN No.")]
        public string SiteNcrSRNNo { get; set; }
        [Display(Name = "Supplier")]
        [MaxLength(128)]
        public string Supplier { get; set; }
        [Display(Name = "Part No.")]
        [MaxLength(50)]
        public string PartNo { get; set; }
        [Display(Name = "Man. Part No.")]
        [MaxLength(50)]
        public string ManPartNo { get; set; }
        [Display(Name = "Part Description")]
        [MaxLength(50)]
        public string PartDescription { get; set; }
        [Display(Name = "Batch Qty.")]
        public int? BatchQty { get; set; }
        [Display(Name = "Reject Qty.")]
        public int? RejectQty { get; set; }
        [Display(Name = "PO No.")]
        [MaxLength(50)]
        public string PONo { get; set; }
        [Display(Name = "Unit Price")]
        public decimal? UnitPrice { get; set; }
        [DataType(DataType.Date)]
        [Display(Name = "Required Date")]
        public DateTime? FRRequiredDate { get; set; }
        [Display(Name = "GRN No.")]
        [MaxLength(50)]
        public string GRNNo { get; set; }
        [Display(Name = "Date Code/Batch No.")]
        [MaxLength(50)]
        public string DateCodeBatchNo { get; set; }
        [Display(Name = "Works Order No.")]
        [MaxLength(50)]
        public string WorksOrderNo { get; set; }
        [Display(Name = "Buyer")]
        [MaxLength(128)]
        public string Buyer { get; set; }
        [Display(Name = "Raise a shortage?")]
        [MaxLength(128)]
        public string RaiseAShortage { get; set; }
        [Display(Name = "Fault Category")]
        [MaxLength(128)]
        public string FaultCategory { get; set; }
        [Display(Name = "Shortage Qty.")]
        public int? ShortageQty { get; set; }
        [Display(Name = "Source of Rejection")]
        [MaxLength(128)]
        public string SourceOfRejection { get; set; }
        [DataType(DataType.MultilineText)]
        [Display(Name = "Detail")]
        [MaxLength(500)]
        public string Detail { get; set; }
        [DataType(DataType.Date)]
        [Display(Name = "NCR Date")]
        public DateTime? NCRDate { get; set; }
        [DataType(DataType.Date)]
        [Display(Name = "MRP Return Date")]
        public DateTime? MRPReturnDate { get; set; }
        [DataType(DataType.Date)]
        [Display(Name = "Required Date")]
        public DateTime? CARequiredDate { get; set; }
        [Display(Name = "Packing Note No.")]
        [MaxLength(50)]
        public string PackingNoteNo { get; set; }
        [Display(Name = "Disruption Severity")]
        [MaxLength(128)]
        public string DFDisruptionSeverity { get; set; }

        //ncr导入新增字段
        public int? POOrderID { get; set; }
        [MaxLength(20)]
        public string POOrderNumber { get; set; }
        public int? POLineID { get; set; }
        [MaxLength(20)]
        public string POLineNumber { get; set; }
        public int? PSID { get; set; }
        [MaxLength(50)]
        public string PSName { get; set; }
        public int? GRNID { get; set; }
        [MaxLength(20)]
        public string GRNNumber { get; set; }
        public int? SupplierID { get; set; }
        public int? CustomerID { get; set; }
        public int? NCRNo { get; set; }
    }
}