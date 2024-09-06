import 'package:al_rova/utils/constants/app_style.dart';
import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/images.dart';
import 'package:flutter/material.dart';

class BestDealsItem extends StatelessWidget {
  final VoidCallback? onTap, onEditClick, onDeleteClick, onAddToWishlistClick;
  bool isSeller;
  String? percentageOff;
  String? productTitle;
  String? productPrice;
  String? productSalePrice;
  String? productImage;
  String? productSize;
  String? productType;
  String? baseUrl;
  bool? isWishList;
  BestDealsItem({
    super.key,
    this.onTap,
    this.onEditClick,
    this.onDeleteClick,
    required this.isSeller,
    this.percentageOff,
    this.productTitle,
    this.productPrice,
    this.productSalePrice,
    this.productImage,
    this.productSize,
    this.productType,
    this.baseUrl,
    this.onAddToWishlistClick,
    this.isWishList,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2 - 20,
        constraints: const BoxConstraints(
          maxHeight: double.infinity,
        ),
        decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(width: 1, color: const Color(0xffDEDEDE)),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Color(0xffEAFAE9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                      )),
                  child: Center(
                    child: Text(
                      '${percentageOff ?? '50'}% Off',
                      textAlign: TextAlign.center,
                      style: headLine6.copyWith(
                          fontSize: 13, color: const Color(0xff0A7D00)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: !isSeller ? 8 : 0),
                  child: !isSeller
                      ? InkWell(
                          onTap: onAddToWishlistClick,
                          child: Icon(
                            Icons.favorite_rounded,
                            color: isWishList!
                                ? Colors.red
                                : const Color(0xffDEDEDE),
                          ),
                        )
                      : PopupMenuButton<int>(
                          itemBuilder: (context) => [
                            // PopupMenuItem 1
                            const PopupMenuItem(
                              value: 1,
                              // row with 2 children
                              child: Row(
                                children: [
                                  Icon(Icons.edit_rounded),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Edit")
                                ],
                              ),
                            ),
                            // PopupMenuItem 2
                            const PopupMenuItem(
                              value: 2,
                              // row with two children
                              child: Row(
                                children: [
                                  Icon(Icons.delete_rounded),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Delete")
                                ],
                              ),
                            ),
                          ],
                          offset: const Offset(20, 40),
                          color: AppColors.lightGary,
                          elevation: 2,
                          // on selected we show the dialog box
                          onSelected: (value) {
                            // if value 1 show dialog
                            if (value == 1) {
                              onEditClick!();
                            } else if (value == 2) {
                              onDeleteClick!();
                            }
                          },
                        ),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
                child: productImage == null || productImage!.isEmpty
                    ? Image.asset(
                        Images.product,
                        width: 48,
                        height: 85,
                      )
                    : Image.network(
                        'https://developement_rovo.acelucid.com$productImage',
                        width: 60,
                        height: 85,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Images.product,
                            width: 48,
                            height: 85,
                          );
                        },
                      )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productTitle ?? 'EMAPRO insecticide',
                    style: headLine5.copyWith(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    '₹ ${productSalePrice ?? 100}',
                    style: headLine5.copyWith(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  RichText(
                    text: TextSpan(
                      text: '',
                      children: <TextSpan>[
                        TextSpan(
                            text: '₹ ${productPrice ?? 200}',
                            style: headLine6.copyWith(
                                color: const Color(0xff1B1C1E),
                                decoration: TextDecoration.lineThrough)),
                        TextSpan(
                            text: '   ${'${percentageOff ?? '50'}% Off'}',
                            style: headLine6.copyWith(
                                color: const Color(0xff2382AA),
                                fontSize: 11,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    'Size ${productSize ?? '200'} ${productType ?? 'ml'}',
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: headLine5.copyWith(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
