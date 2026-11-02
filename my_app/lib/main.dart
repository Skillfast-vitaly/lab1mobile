import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(debugShowCheckedModeBanner: false,title: 'calc',
        home: Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String a='',b='',op='';
  String old ='';
  String err = '';
  bool rez=false;

  void tap(String t){
    if(err!='') clr();
     if(t=='C'){clr();}
    else if(t=='D') {del();}
    else if (t=='%'){ proc(); }
    else if(t=='=')
    {
      eq();
    }
    else {put(t);}
    setState((){});
  }

  void clr(){a='';b='';op='';old='';err='';rez=false;}

  void del(){
    if(b!=''){b=b.substring(0,b.length-1);}
    else if(op!=''){op='';}
    else if(a!='') {
      a=a.substring(0,a.length-1);
      if(a=='-') a='';
      rez=false;
    }
  }

  void proc() {
    if(b!=''){b=Calc.fmt(double.parse(b)/100);}
    else if(a!=''&&op==''){
        a=Calc.fmt(double.parse(a)/100);
        rez=true;
    }
  }

  void eq(){
    if(a==''||op==''||b=='') return;
    String s='$a$op$b';
    try {
      double x=Calc.count(double.parse(a),op,double.parse(b));
      a=Calc.fmt(x);rez=true;
    }catch(e){
      err=e.toString().replaceAll('Exception: ','');
      a='';
    }
    old=s; op=''; b='';
  }

  void put(String t){
    if('+-×÷'.contains(t)){
      if(a=='') return;
      if(op!=''&&b!=''){
        eq();
        if(err!='') return;
      }
      op=t;
      return;
    }
   if(op=='') {
      if(rez){a='';old='';rez=false;}
      if(t=='.'&&a.contains('.')) return;
      if(t=='.'&&a=='') t='0.';
      if(a=='0'&&t!='.') a=''; //чтоб не было 05
      a+=t;
    }else{
      if(t=='.'&&b.contains('.')) return;
      if(t=='.'&&b=='') t='0.';
      if(b=='0'&&t!='.') b='';
      b+=t;
   }
  }

  Color col(String t){
    if('0123456789.'.contains(t)) return const Color(0xffe9e4d8);
    if(t=='C') return Colors.red.shade400;
    if(t=='=')return const Color(0xff4caf50);
    if (t=='D'||t=='%') return Colors.blueGrey;
    return const Color(0xff5b7db1);//Colors.orange
  }

  Widget k(String t,{int f=1}) {
    return Expanded(flex: f,child: Padding(padding: const EdgeInsets.all(5),
      child: GestureDetector(onTap: ()=>tap(t),
        child: Container(alignment: Alignment.center,
          decoration: BoxDecoration(color: col(t),borderRadius: BorderRadius.circular(7),
            boxShadow: const [BoxShadow(color: Colors.black54,offset: Offset(0,4))]),
          child: Text(t,style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold,
              color: '0123456789.'.contains(t)?const Color(0xff333333):Colors.white)),
        ),
      )));
  }

  Widget r(List<Widget> l)=>Expanded(child: Row(crossAxisAlignment: CrossAxisAlignment.stretch,children: l));

  @override
  Widget build(BuildContext context) {
    String s=a+op+b;
    if(s=='') s='0';
    if(err!='') s=err;
    //print(s);
    return Scaffold(
      backgroundColor: const Color(0xff1b1f23),
      body: SafeArea(child: Container(
          margin: const EdgeInsets.all(8),padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xff39424e),borderRadius: BorderRadius.circular(22)),
          child: Column(children: [
            Expanded(flex: 2,child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              alignment: Alignment.bottomRight,
              decoration: BoxDecoration(color: const Color(0xffa9b89a),border: Border.all(width: 3),borderRadius: BorderRadius.circular(8)),
              child: FittedBox(fit: BoxFit.scaleDown,child: Column(crossAxisAlignment: CrossAxisAlignment.end,children: [
                Text(old,style: const TextStyle(fontSize: 22,color: Color(0xff4a5a40))),
                Text(s,style: const TextStyle(fontSize: 52,fontWeight: FontWeight.w600,color: Color(0xff1e2a1e))),
              ])),
            )),
            Expanded(flex: 5,child: Column(children: [
              Expanded(flex: 4,child: Row(crossAxisAlignment: CrossAxisAlignment.stretch,children: [
                Expanded(flex: 3,child: Column(children: [
                  r([k('1'),k('2'),k('3')]),
                  r([k('4'),k('5'),k('6')]),
                  r([k('7'),k('8'),k('9')]),
                  r([k('0',f: 2),k('.')]),
                ])),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: [k('÷'),k('×'),k('-'),k('+')])),
              ])),
              r([k('C'),k('D'),k('%'),k('=')]),
            ])),
          ]),
        )),
    );
  }
}

//логика
class Calc{
  static double count(double x,String o,double y){
    if(o=='+') return x+y;
    if(o=='-') return x-y;
    if (o=='×') return x*y;
    if(y==0) throw Exception('Нельзя поделить на 0');
    return x/y;
  }

  static String fmt(double x) {
    String s=x.toString();
    if(s.endsWith('.0')) s=s.substring(0,s.length-2);
    return s;
  }
}