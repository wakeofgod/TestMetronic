//alert('hello world in TypeScript!');
//通过类型批注提供静态类型以在编译时启动类型检查
//简单函数，输出面积
//function area(shape: string, width: number, height: number) {
//    var area = width * height;
//    return "I'm a" + shape + " with an area of " + area + " cm squared.";
//}
//document.body.innerHTML = area("rectangle", 30, 15);

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
class Shape {
    area: number;
    color: string;
    constructor(public name: string, width: number, height: number) {
        this.area = width * height;
        this.color = "pink";
    };
    shoutout() {
        return "I'm " + this.color + " " + this.name + " with an area of " + this.area + " cm squared.";
    }
}
//var square = new Shape("square", 30, 30);

//console.log(square.shoutout());
//console.log('Area of Shape: ' + square.area);
//console.log('Name of Shape: ' + square.name);
//console.log('Color of Shape: ' + square.color);
//console.log('Width of Shape: ' + square.width);
//console.log('Height of Shape: ' + square.height);

//继承
class Shape3D extends Shape {
    volume: number;
    constructor(public name: string, width: number, height: number, length: number) {
        //继承父类的属性
        super(name, width, height);
        this.volume = length * this.area;
    };
    shoutout() {
        return "I'm " + this.name + " with a volume of " + this.volume + " cm cube.";
    }
    superShout() {
        //调用父类的方法
        return super.shoutout();
    }
}
var cube = new Shape3D("cube", 30, 30, 30);
console.log(cube.shoutout());
console.log(cube.superShout());

//枚举
enum AlertLevel {
    info,
    warning,
    error
}
function getAlertSubscribers(level: AlertLevel) {
    var emails = new Array<string>();
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
function add(...foo: number[]): number {
    var result = 0;
    for (var i = 0; i < foo.length; i++){
        result += foo[i];
    }
    return result;      
}
//直接用数组传参数
function add2(foo: number[]): number {
    var result = 0;
    for (var i = 0; i < foo.length; i++){
        result += foo[i];
    }
    return result;
}
//函数重载
function test(name: string): string;
function test(age: number): string;
function test(single: boolean): string;
//实现函数签名必须兼容所有的重载签名，总是在参数列表的最后
//编译成js后只有一个函数，而不是三个
function test(value: (string | number | boolean)): string {
    switch (typeof value) {
        //模板字符串，使用反引号，可以包含占位符
        case "string":
            return `my name is $(value).`;
        case "number":
            return `i'm $(value) years old`;
        case "boolean":
            return value ? "i'm single" : "i'm not single";
        default:
            console.log("invalid operation");
    }
}
//typescript的重载是假实现
function test2(name: string): string;
function test2(a: number, b: number): string;
function test2(a: number, b: number, c: boolean): string;
function test2(): string {
    return "";
}
//使用let关键字，bar变量只能在if代码块中，不会变量提升到函数foo的顶端
function foo1(): void {
    if (true) {
        let bar: number = 0;
        bar = 1;
    }
    //alert(bar); 报错
}
//const和let具有同样的作用域
function foo2(): void {
    if (true) {
        const bar: number = 0;
        //bar = 1;报错不能被重新复制
    }
    //alert(bar); 报错
}
//立即调用函数 IIFE
var bar = 0;
(function () {
    var foo3: Number = 0;
    bar = 1;
    console.log(bar);
    console.log(foo3);
})();


