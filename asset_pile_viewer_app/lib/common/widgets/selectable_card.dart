import 'package:assetPileViewer/common/widgets/selected_widget_controller.dart';
import 'package:flutter/material.dart';

class SelectableCard extends StatefulWidget {
  final bool selected;
  final bool disabled;
  final Widget? child;
  final void Function()? onEnter;
  final void Function()? onHover;
  final void Function()? onExit;
  final void Function(bool selected)? onChange;
  final Color? selectedColor;
  final Color? disabledColor;
  final SelectedWidgetController? controller;
  const SelectableCard(
      {super.key,
      this.child,
      this.selected = false,
      this.disabled = false,
      this.onEnter,
      this.onHover,
      this.onExit,
      this.onChange,
      this.selectedColor,
      this.disabledColor,
      this.controller});

  @override
  State<SelectableCard> createState() => _SelectableCardState();
}

class _SelectableCardState extends State<SelectableCard> {
  bool _selected = false;
  bool _mouseOver = false;

  @override
  void initState() {
    _selected = widget.selected;

    if (_selected) {
      widget.controller?.change(widget, _selected);
    }

    widget.controller?.addListener(() {
      final selected = widget.controller!.has(widget);
      if (selected == _selected) {
        return;
      }
      setState(() {
        _selected = selected;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final disabledColor = widget.disabledColor ?? Colors.grey;
    final selectedColor =
        widget.selectedColor ?? Theme.of(context).colorScheme.inversePrimary;
    return GestureDetector(
      onTap: widget.disabled
          ? null
          : () {
              if (widget.onChange != null) {
                widget.onChange!(!_selected);
              }
              if (widget.controller != null) {
                widget.controller!.change(widget, !_selected);
                return;
              }
              setState(() {
                _selected = !_selected;
              });
            },
      child: MouseRegion(
        onEnter: widget.disabled
            ? null
            : (event) {
                if (widget.onEnter != null) {
                  widget.onEnter!();
                }
                setState(() {
                  _mouseOver = true;
                });
              },
        onExit: widget.disabled
            ? null
            : (event) {
                if (widget.onExit != null) {
                  widget.onExit!();
                }
                setState(() {
                  _mouseOver = false;
                });
              },
        onHover: widget.disabled
            ? null
            : (event) {
                if (widget.onHover != null) {
                  widget.onHover!();
                }
              },
        child: Card(
          color: widget.disabled
              ? disabledColor
              : _selected
                  ? selectedColor
                  : null,
          // surfaceTintColor: widget.disabled
          //     ? null
          //     : _selected
          //         ? widget.selectedColor
          //         : null,
          shape: RoundedRectangleBorder(
            side: _mouseOver
                ? const BorderSide(color: Colors.black, width: 2)
                : BorderSide.none,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }

  void unSelect() {
    setState(() {
      _selected = false;
    });
  }
}
