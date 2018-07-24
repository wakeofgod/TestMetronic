using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace TestMetronic
{
    public class LM_T_CA_ScheduleSettings:A2ZBaseModel
    {
        [Display(Name = "资产编号"), Required]
        public Guid AssetGuid { get; set; }
        [Display(Name = "插件编号"), Required]
        public int ControlId { get; set; }
        [Display(Name = "计划时间类型")]
        public int Type { get; set; }
        [Display(Name = "计划时间单位")]
        public int? Unit { get; set; }
        [Display(Name = "时间")]
        //四种情况共用，保存文本框的数字,不额外加字段
        public int? Quantity { get; set; }
        [Display(Name = "时间频率")]
        public int? Frequency { get; set; }
        [Display(Name = "每周几")]
        public int? WeekDays { get; set; }
        [Display(Name = "设置固定时间")]
        public DateTime? SetDate { get; set; }
        //需求改了，monthday和months，weekdays全部没用了
        [Display(Name = "每月几号")]
        public int? MonthDay { get; set; }
        //选中的月份,多个拼接，全选就设为13
        public string Months { get; set; }
        //新增字段,counter类型需要选择unitcontrol
        public Guid? UnitGuid { get; set; }
    }
    //设置的枚举加两个类型
    public enum ScheduleType
    {
        Calendar = 0,
        Timer = 1,
        Counter=2,
        Ncr=3
    }
}