using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
namespace TestMetronic
{
    public class LM_T_CA_Assets:BaseModel
    {
        [Display(Name = "名称"), MaxLength(40), Required]
        public string Name { get; set; }

        [Display(Name = "公司"), Required]
        public int CompanyID { get; set; }

        [Display(Name = "创建人"), Required]
        public Guid Creator { get; set; }

        public byte[] Icon { get; set; }

        public string FileExtName { get; set; }

        public string FileName { get; set; }

        [Display(Name = "描述"), MaxLength(500)]
        public string Description { get; set; }

        [Display(Name = "所有者"), Required]
        public Guid AssetOwner { get; set; }

        [Display(Name = "制造商")]
        public Guid? Manufacturer { get; set; }

        [Display(Name = "当前位置"), Required]
        public Guid CurrentLocation { get; set; }

        [Display(Name = "存放位置"), Required]
        public Guid StorageLocation { get; set; }

        [Display(Name = "工具类型")]
        public Guid? Type { get; set; }

        [Display(Name = "状态"), Required]
        public Guid Status { get; set; }

        [Display(Name = "状态1")]
        public Guid? Status1 { get; set; }

        public DateTime? DateAcquired { get; set; }

        public int OrderIndex { get; set; }

        //2018/08/28 新加5个字段
        public Guid? Sheet { get; set; }
        [MaxLength(40)]
        public string Units { get; set; }

        public float? Resolution { get; set; }
        public float? Range1 { get; set; }
        public float? Range2 { get; set; }
        //2018/09/12加字段,资产类型
        public EquipmentType EquipType { get; set; }
        //2019/02/22添加字段
        [MaxLength(30)]
        public string QRCode { get; set; }
    }
    public enum EquipmentType
    {
        Standard=0,
        Reference=1
    }
}