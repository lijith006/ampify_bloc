import 'package:flutter/material.dart';
import 'package:clippy_flutter/arc.dart';

class ProductArcWidget extends StatelessWidget {
  final String productName;
  final double productPrice;

  const ProductArcWidget({
    super.key,
    required this.productName,
    required this.productPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Arc(
      height: 30,
      edge: Edge.TOP,
      arcType: ArcType.CONVEY,
      child: Container(
        width: double.infinity,
        color: const Color.fromARGB(255, 218, 229, 243),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        productName,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 85, 86, 94),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      " \₹${productPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF6F61),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
