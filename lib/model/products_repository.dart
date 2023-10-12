// Copyright 2018-present the Flutter authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class ProductsRepository {
  static Future<List<Product>> fetchProducts(Category category) async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body)['products'];

      List<Product> allProducts = jsonList.map((json) {
        Category mappedCategory;
        switch (json['category']) {
          case 'home-decoration':
            mappedCategory = Category.decorations;
            break;
          case 'smartphones':
            mappedCategory = Category.smartphones;
            break;
          case 'laptops':
            mappedCategory = Category.laptops;
            break;
          case 'fragrances':
            mappedCategory = Category.fragrances;
            break;
          case 'skincare':
            mappedCategory = Category.skincare;
            break;
          case 'groceries':
            mappedCategory = Category.groceries;
            break;
          default:
            mappedCategory = Category.all;
            break;
        }
        return Product(
          category: mappedCategory,
          name: json['title'],
          price: json['price'],
          isFeatured: Random().nextBool(),
          image: json['images'][0],
        );
      }).toList();
      if (category == Category.all) {
        return allProducts;
      } else {
        return allProducts.where((Product p) {
          return p.category == category;
        }).toList();
      }
    } else {
      throw Exception('Failed to load products');
    }
  }
}
