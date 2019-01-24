using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace TestMetronic.A2ZModel
{
    public class LM_T_NCRs_ActionLog:BaseModel
    {
        [Display(Name = "事件源"),Required]
        public Guid SourceID { get; set; }
        public int CompanyID { get; set; }
        public int UserID { get; set; }
        [Display(Name = "内容描述"), MaxLength(500)]
        public string EventContent { get; set; }
        [Display(Name ="事件类型")]
        public int EventType { get; set; }
        public DateTime CreateTime { get; set; }
    }
}