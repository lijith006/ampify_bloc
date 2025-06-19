import 'package:flutter/material.dart';

class OrderUtils {
  static Color getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.green;
      case 'Delivered':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
