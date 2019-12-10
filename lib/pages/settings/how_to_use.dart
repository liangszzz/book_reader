import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HowToUse extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HowToUseState();
}

class _HowToUseState extends State<HowToUse> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("使用说明")),
      body: Stepper(
        currentStep: _step,
        steps: _buildSteps(),
        onStepContinue: () {
          setState(() {
            if (_step >= 3)
              _step = 0;
            else {
              _step += 1;
            }
          });
        },
      ),
    );
  }

  List<Step> _buildSteps() {
    return <Step>[
      Step(
          title: Text("第一步"),
          content: Text("打开支持列表的网站"),
          state: StepState.complete,
          isActive: true),
      Step(title: Text("第二步"), content: Text("选择一本书籍")),
      Step(title: Text("第三步"), content: Text("复制该书籍的地址")),
      Step(title: Text("第四步"), content: Text("在书架页粘贴地址,点击  +  按钮")),
    ];
  }
}
