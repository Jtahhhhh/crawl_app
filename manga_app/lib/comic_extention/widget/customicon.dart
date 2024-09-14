import 'package:flutter/material.dart';

class CustomIcon extends StatefulWidget {
  CustomIcon(
      {Key? key,
        this.onPress,
        required this.image,
        this.size,
        this.color,
        this.title = const SizedBox(),
        this.gradient,
        this.tooltip
      })
      : super(key: key);

  Function()? onPress;
  String image;
  double? size;
  Color? color;
  Widget title;
  List<Color>? gradient;
  String? semanticLabel;
  String? tooltip;

  @override
  State<CustomIcon> createState() => _CustomIconState();
}

class _CustomIconState extends State<CustomIcon> {
  @override
  Widget build(BuildContext context) {
    return widget.onPress != null
        ? IconButton(
      tooltip: widget.tooltip,
      onPressed: widget.onPress,
      icon: (widget.gradient?.isNotEmpty ?? false)
          ? ShaderMask(
        shaderCallback: (Rect bounds) => RadialGradient(
          center: Alignment.topLeft,
          tileMode: TileMode.repeated,
          colors: widget.gradient ?? [],
        ).createShader(bounds),
        child: _icon(widget),
      )
          : _icon(widget),
    )
        : (widget.gradient?.isNotEmpty ?? false)
        ? ShaderMask(
      shaderCallback: (Rect bounds) => RadialGradient(
        center: Alignment.topLeft,
        tileMode: TileMode.repeated,
        colors: widget.gradient ?? [],
      ).createShader(bounds),
      child: _icon(widget),
    )
        : _icon(widget);
  }

  Widget _icon(CustomIcon widget) => Stack(
    alignment: Alignment.center,
    children: [
      Semantics(
        label: widget.semanticLabel,
        child: Image(
          image: widget.image.contains('http')
              ? NetworkImage(
            widget.image,
          )
              : AssetImage(widget.image) as ImageProvider,
          width: widget.size,
          height: widget.size,
          color: widget.color,
          fit: BoxFit.scaleDown,
          excludeFromSemantics: true,
        ),
      ),
      widget.title,
    ],
  );
}
