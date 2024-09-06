import 'package:flutter/material.dart';

class BuildPaymentMethods extends StatefulWidget {
  final Function()? onTap;
  final String text;
  final String? textt;
  final String image;
  final IconData icon;
  final bool? isOpen;
  final String? additionalContent;
  final String? data;
  final Function()? onPressed;

  const BuildPaymentMethods({
    super.key,
    this.onTap,
    required this.text,
    required this.image,
    required this.icon,
    this.isOpen,
    this.additionalContent,
    this.data,
    this.textt,
    this.onPressed,
  });

  @override
  State<BuildPaymentMethods> createState() => _BuildPaymentMethodsState();
}

class _BuildPaymentMethodsState extends State<BuildPaymentMethods> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(10),
        height: widget.isOpen != null
            ? widget.isOpen!
                ? widget.additionalContent != null
                    ? 250
                    : 300
                : 85
            : 85,
        width: double.infinity,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(240, 254, 223, 1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color.fromRGBO(181, 238, 166, 1))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(widget.image),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 0, 0, 1),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: widget.onTap,
                      child: Icon(
                        widget.icon,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (widget.isOpen != null &&
                widget.isOpen! &&
                widget.additionalContent != null)
              const SizedBox(height: 10),
            if (widget.isOpen != null &&
                widget.isOpen! &&
                widget.additionalContent != null)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      widget.textt.toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: widget.onPressed,
                      child: Container(
                        height: 52,
                        width: 285,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(74, 141, 52, 1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                            child: Text(
                          widget.data.toString(),
                          style: const TextStyle(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              fontSize: 24),
                        )),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
