//alert('hello world in TypeScript!');
//通过类型批注提供静态类型以在编译时启动类型检查
//简单函数，输出面积
//function area(shape: string, width: number, height: number) {
//    var area = width * height;
//    return "I'm a" + shape + " with an area of " + area + " cm squared.";
//}
//document.body.innerHTML = area("rectangle", 30, 15);
var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
//接口
//interface Shape {
//    name: string;
//    width: number;
//    height: number;
//    color?: string;
//}
//function area(shape: Shape) {
//    var area = shape.width * shape.height;
//    return "I'm " + shape.name + " with area " + area + " cm squared";
//}
//console.log(area({ name: "rectangle", width: 30, height: 15 }));
//console.log(area({ name: "square", width: 30, height: 30, color: "blue" }));
////缺少name参数，编译不通过，强制运行，页面不崩溃
////console.log(area({ width: 30, height: 15 }));
//使用lambda表达式
//var shape = {
//    name: "rectangle",
//    popup: function () {
//        console.log('This inside popup():' + this.name);
//        setTimeout(function () {
//            console.log('This inside setTimeout(): ' + this.name);
//            console.log("I'm a " + this.name + "!");
//        }, 2000);
//        //使用lambda可以调用name值，否则为空
//        setTimeout(() => {
//            console.log('This inside setTimeout(): ' + this.name);
//            console.log("I'm a " + this.name + "!");
//        }, 2000);
//    }
//};
//shape.popup();
//类
var Shape = (function () {
    function Shape(name, width, height) {
        this.name = name;
        this.area = width * height;
        this.color = "pink";
    }
    ;
    Shape.prototype.shoutout = function () {
        return "I'm " + this.color + " " + this.name + " with an area of " + this.area + " cm squared.";
    };
    return Shape;
}());
//var square = new Shape("square", 30, 30);
//console.log(square.shoutout());
//console.log('Area of Shape: ' + square.area);
//console.log('Name of Shape: ' + square.name);
//console.log('Color of Shape: ' + square.color);
//console.log('Width of Shape: ' + square.width);
//console.log('Height of Shape: ' + square.height);
//继承
var Shape3D = (function (_super) {
    __extends(Shape3D, _super);
    function Shape3D(name, width, height, length) {
        var _this = 
        //继承父类的属性
        _super.call(this, name, width, height) || this;
        _this.name = name;
        _this.volume = length * _this.area;
        return _this;
    }
    ;
    Shape3D.prototype.shoutout = function () {
        return "I'm " + this.name + " with a volume of " + this.volume + " cm cube.";
    };
    Shape3D.prototype.superShout = function () {
        //调用父类的方法
        return _super.prototype.shoutout.call(this);
    };
    return Shape3D;
}(Shape));
var cube = new Shape3D("cube", 30, 30, 30);
console.log(cube.shoutout());
console.log(cube.superShout());
//枚举
var AlertLevel;
(function (AlertLevel) {
    AlertLevel[AlertLevel["info"] = 0] = "info";
    AlertLevel[AlertLevel["warning"] = 1] = "warning";
    AlertLevel[AlertLevel["error"] = 2] = "error";
})(AlertLevel || (AlertLevel = {}));
function getAlertSubscribers(level) {
    var emails = new Array();
    switch (level) {
        case AlertLevel.info:
            emails.push("cst@domain.com");
            break;
        case AlertLevel.warning:
            emails.push("development@domain.com");
            emails.push("sysadmin@domain.com");
            break;
        case AlertLevel.error:
            emails.push("development@domain.com");
            emails.push("sysadmin@domain.com");
            emails.push("management@domain.com");
            break;
        default: throw new Error("Invalid argument");
    }
    debugger;
    //return emails;
    for (var e in emails) {
        console.log(emails[e]);
    }
}
getAlertSubscribers(AlertLevel.info);
getAlertSubscribers(AlertLevel.warning);
//可选参数
//默认参数
//剩余参数,会被自动解析为javascript的argument的内建对象
function add() {
    var foo = [];
    for (var _i = 0; _i < arguments.length; _i++) {
        foo[_i] = arguments[_i];
    }
    var result = 0;
    for (var i = 0; i < foo.length; i++) {
        result += foo[i];
    }
    return result;
}
//直接用数组传参数
function add2(foo) {
    var result = 0;
    for (var i = 0; i < foo.length; i++) {
        result += foo[i];
    }
    return result;
}
//实现函数签名必须兼容所有的重载签名，总是在参数列表的最后
//编译成js后只有一个函数，而不是三个
function test(value) {
    switch (typeof value) {
        //模板字符串，使用反引号，可以包含占位符
        case "string":
            return "my name is $(value).";
        case "number":
            return "i'm $(value) years old";
        case "boolean":
            return value ? "i'm single" : "i'm not single";
        default:
            console.log("invalid operation");
    }
}
function test2() {
    return "";
}
//使用let关键字，bar变量只能在if代码块中，不会变量提升到函数foo的顶端
function foo1() {
    if (true) {
        var bar_1 = 0;
        bar_1 = 1;
    }
    //alert(bar); 报错
}
//const和let具有同样的作用域
function foo2() {
    if (true) {
        var bar_2 = 0;
        //bar = 1;报错不能被重新复制
    }
    //alert(bar); 报错
}
//立即调用函数 IIFE
var bar = 0;
(function () {
    var foo3 = 0;
    bar = 1;
    console.log(bar);
    console.log(foo3);
})();
//# sourceMappingURL=hello.js.map