using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    public class LM_T_CA_AssetActionLog:BaseModel
    {
        [Display(Name = "资产"), Required]
        public Guid AssetGuid { get; set; }
        [Display(Name = "操作人"), Required]
        public Guid Operator { get; set; }
        [Display(Name = "事件描述"), Required]
        public string EventContent { get; set; }
        [Display(Name = "事件类型"), Required]
        public int EnvenType { get; set; }
        [Display(Name = "记录时间"), Required]
        public DateTime  RecordTime { get; set; }
    }
    public enum AssetEventType
    {
        Create=0,
        EditProp=1,
        EditFile=2,
        EditSchedule=3,
        Calibration=4
    }
}