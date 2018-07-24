using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    public class LM_T_CA_UsageLogs:A2ZBaseModel
    {
        [Display(Name = "资产编号"), Required]
        public Guid AssetGuid { get; set; }
        [Display(Name = "创建人"), Required]
        public Guid Creator { get; set; }
        [Display(Name = "创建时间"), Required]
        public DateTime CreateTime { get; set; }
        [Display(Name = "总用时"), Required]
        public string TimeUsed { get; set; }
        [Display(Name = "测量总数"), Required]
        public int TotalUse { get; set; }
        [Display(Name = "Ncr总数"), Required]
        public int TotalNcr { get; set; }
    }
    public class LM_T_CA_UsageJobDetail : A2ZBaseModel
    {
        [Display(Name = "日志编号"), Required]
        public Guid LogsGuid { get; set; }
        [Display(Name = "job编号"), Required]
        public string JobNo { get; set; }
        [Display(Name = "工作起始时间"), Required]
        public DateTime StartTime { get; set; }
        [Display(Name = "工作结束时间"), Required]
        public DateTime EndTime { get; set; }
        [Display(Name = "测量零件总数"), Required]
        public int Quantity { get; set; }
        [Display(Name = "零件编号")]
        public string PartNo { get; set; }
        [Display(Name = "问题编号")]
        public string IssueNo { get; set; }
        [Display(Name = "NCR编号")]
        public string NcrNo { get; set; }
        [Display(Name = "NCR数量")]
        public int NcrQty { get; set; }
        [Display(Name = "创建时间"), Required]
        public DateTime CreateTime { get; set; }
    }
    public class LM_T_CA_MultiJobs:A2ZBaseModel
    {
        [Display(Name = "关联工作"), Required]
        public Guid JobGuid { get; set; }
        [Display(Name = "NCR编号")]
        public string NcrNo { get; set; }
        [Display(Name = "NCR数量")]
        public int NcrQty { get; set; }
    }
}