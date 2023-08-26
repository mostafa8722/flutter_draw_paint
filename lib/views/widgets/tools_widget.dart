
import 'package:doddle/bussiness_logic/bloc/home/home_bloc.dart';
import 'package:doddle/bussiness_logic/bloc/record/recorder_bloc.dart';
import 'package:doddle/data/enums/pen_tool.dart';
import 'package:doddle/data/enums/tool_type.dart';
import 'package:doddle/data/utils/ad_helper.dart';
import 'package:doddle/generated/assets.gen.dart';
import 'package:doddle/views/widgets/popover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ToolsWidget extends StatefulWidget{

  @override
  State<StatefulWidget> createState() =>ToolsWedgetState();
}

class ToolsWedgetState extends State<ToolsWidget>{

  late RewardedAd _rewardedAd;
  bool _isRewardedAready =false;
  bool _isEraserSelected =false;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  @override
  void initState() {

   _loadRewardedAd();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => RecorderBloc(),
        ),
      ],
      child: Container(
        height: MediaQuery.of(context).size.height * .1,
        color: Colors.purple[800],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: Assets.svg.pen.svg(
                width: 50,
              ),
              onTap: () {
                _handleFABPressed(context, ToolType.brushs);
              },
            ),
            GestureDetector(
              child: Assets.svg.eraser.svg(
                width: 60,
              ),
              onTap: () {
                BlocProvider.of<HomeBloc>(context)
                    .add(ChangePenToolEvent(penTool: PenTool.earserPen));
              },
            ),
            GestureDetector(
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Assets.svg.symmetricalLineBg.svg(
                  width: 80,
                ),
                Assets.svg.symmtricalLine6.svg(
                  width: 60,
                )
              ]),
              onTap: () {
                _handleFABPressed(context, ToolType.symmyrticllLine);
              },
            ),
            GestureDetector(
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Assets.svg.colorBorder.svg(
                  width: 70,
                ),
                Assets.svg.randomColor.svg(
                  width: 61,
                ),
              ]),
              onTap: () {
                _handleFABPressed(context, ToolType.colors);
              },
            ),
            // GestureDetector(
            //   child: const Icon(
            //     Icons.play_circle,
            //     size: 36,
            //   ),
            //   onTap: () {
            //     print(
            //         context.read<RecorderBloc>().recorderController.toString());
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>  MovieTimePage()),
            //     );
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: Dispose a RewardedAd object
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _handleFABPressed(BuildContext context, ToolType toolType) {
    showModalBottomSheet<int>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Popover(
          child: _buildToolSettings(context, toolType),
        );
      },
    );
  }
  void _loadRewardedAd(){
    RewardedAd.load(adUnitId: AdHelper.rewardedAdUnitId, request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad){
              this._rewardedAd = ad;
              ad.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad){

                  setState(() {
                    _isRewardedAready =false;
                  });
                  _loadRewardedAd();
                }
              );
              setState(() {
                _isRewardedAready =true;
              });
            }, onAdFailedToLoad: (e){
              print("failed to load a rewarded ad: ${e.message}");
    }));
  }


  void changeColor(Color color){
    setState(() {
      pickerColor = color;
    });
  }
  Widget buildBrushesTool(BuildContext context) {
    final theme = Theme.of(context);
    var brushes = [
      BrushTool(
          penTool: PenTool.glowPen, picture: Assets.svg.pen1Preview.svg()),
      BrushTool(
          penTool: PenTool.normalPen, picture: Assets.svg.pen2Preview.svg()),
      // BrushTool(
      // penTool: PenTool.normalPen, picture: Assets.svg.pen3Preview.svg()),
      // BrushTool(
      // penTool: PenTool.normalPen, picture: Assets.svg.pen4Preview.svg()),
      BrushTool(
          penTool: PenTool.glowWithDotsPen,
          picture: Assets.svg.pen5Preview.svg()),
      BrushTool(
          penTool: PenTool.normalWithShaderPen,
          picture: Assets.svg.pen6Preview.svg()),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: brushes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            final brush = brushes[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  child: brush.picture,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<HomeBloc>(context)
                      .add(ChangePenToolEvent(penTool: brush.penTool));
                  Navigator.of(context).pop();
                  _rewardedAd?.show(
                      onUserEarnedReward:
                          (AdWithoutView ad, RewardItem reward) {});
                },
              ),
            );
          }),
    );
  }

  Widget _buildToolSettings(BuildContext context, ToolType toolType) {
    if (toolType == ToolType.colors) {
      return buildColorTool(context);
    } else if (toolType == ToolType.symmyrticllLine) {
      return buildSymmyrticllLinesTool(context);
    } else if (toolType == ToolType.brushs) {
      return buildBrushesTool(context);
    }
    return buildColorTool(context);
  }
  Widget buildSymmyrticllLinesTool(BuildContext context) {
    final theme = Theme.of(context);
    final symmtricalLines = [
      SymmtriclLine(count: 1, picture: Assets.svg.symmtricalLine1.svg()),
      SymmtriclLine(count: 2, picture: Assets.svg.symmtricalLine2.svg()),
      // SymmtriclLine(count: 3, picture: Assets.svg.symmtricalLine3.svg()),
      // SymmtriclLine(count: 4, picture: Assets.svg.symmtricalLine4.svg()),
      SymmtriclLine(count: 3, picture: Assets.svg.symmtricalLine5.svg()),
      // SymmtriclLine(count: 6, picture: Assets.svg.symmtricalLine6.svg()),
      SymmtriclLine(count: 4, picture: Assets.svg.symmtricalLine7.svg()),
      SymmtriclLine(count: 8, picture: Assets.svg.symmtricalLine8.svg()),
      SymmtriclLine(count: 5, picture: Assets.svg.symmtricalLine9.svg()),
      SymmtriclLine(count: 10, picture: Assets.svg.symmtricalLine10.svg()),
      SymmtriclLine(count: 6, picture: Assets.svg.symmtricalLine11.svg()),
      // SymmtriclLine(count: 12, picture: Assets.svg.symmtricalLine12.svg()),
      // SymmtriclLine(count: 8, picture: Assets.svg.symmtricalLine13.svg()),
      // SymmtriclLine(count: 16, picture: Assets.svg.symmtricalLine14.svg()),
      // SymmtriclLine(count: 15, picture: Assets.svg.symmtricalLine15.svg()),
      // SymmtriclLine(count: 32, picture: Assets.svg.symmtricalLine16.svg()),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: GridView.builder(
          shrinkWrap: true,
          itemCount: symmtricalLines.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemBuilder: (BuildContext context, int index) {
            final symmtricalLine = symmtricalLines[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  child: symmtricalLine.picture,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<HomeBloc>(context).add(
                      UpdateSymmetryLinesEvent(symmetryLines: symmtricalLine.count));
                  Navigator.of(context).pop();
                },
              ),
            );
          }),
    );
  }

  Widget buildColorTool(BuildContext context) {
    final colors = [
      Colors.green,
      Colors.black,
      Colors.blue,
      Colors.red,
      Colors.grey,
      Colors.yellow,
      Colors.purple,
      Colors.indigo,
      Colors.lime,
      Colors.orange,
      "Random Color",
      "Color Picker"
    ];
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 16.0,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: colors.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          final color = colors[index];
          if (color is Color) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white70, width: 3),
                  ),
                ),
                onTap: () {
                  BlocProvider.of<HomeBloc>(context)
                      .add(ChangeCurrentColorEvent(color, false));
                  Navigator.of(context).pop();
                },
              ),
            );
          } else {
            if (color == "Random Color") {
              return GestureDetector(
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Assets.svg.colorBorder.svg(
                    width: 60,
                  ),
                  Assets.svg.randomColor.svg(
                    width: 50,
                  ),
                ]),
                onTap: () {
                  BlocProvider.of<HomeBloc>(context).add(
                      ChangeCurrentColorEvent(Color(Colors.green.value), true));
                  Navigator.of(context).pop();
                },
              );
            } else if (color == "Color Picker") {
              return IconButton(
                  onPressed: () {
                    // raise the [showDialog] widget
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Pick a color!'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: pickerColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  BlocProvider.of<HomeBloc>(context).add(
                                      ChangeCurrentColorEvent(
                                          pickerColor, false));
                                  //for the dialog
                                  Navigator.of(context).pop();
                                  //for the model
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.color_lens,
                    color: Colors.red,
                    size: 60,
                  ));
            }
          }
          return Container();
        },
      ),
    );
  }
}



class SymmtriclLine {
  double count;
  SvgPicture picture;
  SymmtriclLine({
    required this.count,
    required this.picture,
  });
}

class BrushTool {
  PenTool penTool;
  SvgPicture picture;
  BrushTool({
    required this.penTool,
    required this.picture,
  });
}