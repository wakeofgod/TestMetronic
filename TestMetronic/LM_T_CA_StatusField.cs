using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    //状态字段
    public class LM_T_CA_StatusField:BaseModel
    {
        [Display(Name = "字段编号"), Required]
        public Guid Field { get; set; }
        //可以为空,同一公司字段事件唯一
        [Display(Name = "事件")]
        public int? EventCode { get; set; }
    }
    //资产检修时间表
    //public class LM_T_CA_AssetSchedule : BaseModel
    //{
    //    [Display(Name = "资产编号"), Required]
    //    public Guid AssetGuid { get; set; }
    //    [Display(Name = "插件编号"), Required]
    //    public int ControlId { get; set; }
    //    [Display(Name = "预设检修时间")]
    //    public DateTime? DueDate { get; set; }
    //    [Display(Name = "状态")]
    //    public int? Status { get; set; }
    //    [Display(Name = "进度条")]
    //    public float? Progress { get; set; }
    //    //第一次检修就是创建时间和预设时间，打开网页时间算差
    //    //第二次就不用createtime了
    //    [Display(Name = "创建时间")]
    //    public DateTime? CreateTime { get; set; }
    //    [Display(Name = "上一次检修的时间")]
    //    public DateTime? LastDueDate { get; set; }
    //}
    ////计划时间设置表
    ////先有时间设置表，再有检修时间,搞反了
    ////直接用资产编号和控件编号关联,不需要用把设置的主键存进时间
    //public class LM_T_CA_ScheduleSettings : BaseModel
    //{
    //    [Display(Name = "资产编号"), Required]
    //    public Guid AssetGuid { get; set; }
    //    [Display(Name = "插件编号"), Required]
    //    public int ControlId { get; set; }
    //    [Display(Name = "计划时间类型")]
    //    public int Type { get; set; }
    //    [Display(Name = "计划时间单位")]
    //    public int? Unit { get; set; }
    //    [Display(Name = "时间")]
    //    public int? Quantity { get; set; }
    //    [Display(Name = "时间频率")]
    //    public int? Frequency { get; set; }
    //    [Display(Name = "每周几")]
    //    public int? WeekDays { get; set; }
    //    [Display(Name = "设置固定时间")]
    //    public DateTime? SetDate { get; set; }
    //    [Display(Name = "每月几号")]
    //    public int? MonthDay { get; set; }
    //    //选中的月份,多个拼接，全选就设为13
    //    public string Months { get; set; }
    //}
    ////资产检修记录表
    public class LM_T_CA_CalibrationRecord:BaseModel
    {
        public Guid AssetGuid { get; set; }
        public DateTime RecordTime { get; set; }
        public float Cost { get; set; }
    }
    //暂时只有这三个，以后会有更多 ,none可以重复
    public enum StatusEvent
    {
        None = 0,
        OutofCalibration = 1,
        InCalibration = 2
    }
    //public enum ScheduleType
    //{
    //    Calendar = 0,
    //    Timer = 1
    //}
    public enum TimeUnit
    {
        Day = 0,
        Week = 1,
        Month = 2
    }
    public enum TimeFrequency
    {
        SetDate = 0,
        Weekly = 1,
        Monthly = 2
    }
    public enum WeekDays
    {
        EveryMonday = 0,
        EveryTuesday = 1,
        EveryWednesday = 2,
        EveryThursday = 3,
        EveryFriday = 4,
        EverySaturday = 5,
        EverySunday = 6
    }
}