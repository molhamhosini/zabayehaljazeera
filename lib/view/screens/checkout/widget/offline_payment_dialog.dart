import 'package:flutter/material.dart';
import 'package:zabayeh_aljazeera/data/model/body/place_order_body.dart';
import 'package:zabayeh_aljazeera/localization/language_constrants.dart';
import 'package:zabayeh_aljazeera/provider/order_provider.dart';
import 'package:zabayeh_aljazeera/utill/dimensions.dart';
import 'package:zabayeh_aljazeera/utill/styles.dart';
import 'package:zabayeh_aljazeera/view/base/custom_button.dart';
import 'package:zabayeh_aljazeera/view/base/custom_loader.dart';
import 'package:zabayeh_aljazeera/view/base/custom_snackbar.dart';
import 'package:zabayeh_aljazeera/view/base/custom_text_field.dart';
import 'package:provider/provider.dart';

class OfflinePaymentDialog extends StatefulWidget {
  final PlaceOrderBody placeOrderBody;
  final Function(PlaceOrderBody) callBack;
  OfflinePaymentDialog({@required this.placeOrderBody, this.callBack});

  @override
  State<OfflinePaymentDialog> createState() => _OfflinePaymentDialogState();
}

class _OfflinePaymentDialogState extends State<OfflinePaymentDialog> {
  TextEditingController paymentByController = TextEditingController();
  TextEditingController transactionIdController = TextEditingController();
  TextEditingController paymentNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 700,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(getTranslated('offline_payment', context), style: poppinsBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),

                  InkWell(
                    onTap: ()=> Navigator.of(context).pop(),
                    child: SizedBox(child: Icon(Icons.clear)),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE,),

              Text(getTranslated('payment_by', context), style: poppinsRegular,),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              CustomTextField(
                isShowBorder: true,
                hintText: 'jhon doe',
                controller: paymentByController,
                inputAction: TextInputAction.next,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

              Text(getTranslated('transaction_id', context), style: poppinsRegular,),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              CustomTextField(
                hintText: 'TRX-XXXX',
                isShowBorder: true,
                controller: transactionIdController,
                inputAction: TextInputAction.next,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

              Text(getTranslated('payment_note', context), style: poppinsRegular,),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              CustomTextField(
                isShowBorder: true,
                controller: paymentNoteController,
                maxLines: 3,
                inputAction: TextInputAction.done,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

              Row(children: [
                Expanded(child: CustomButton(buttonText: getTranslated('cancel', context),
                    backgroundColor: Theme.of(context).hintColor,
                    onPressed: ()=> Navigator.of(context).pop())),
                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                Expanded(child: Consumer<OrderProvider>(
                  builder: (context, orderProvider, _) {
                    return orderProvider.isLoading ? Center(child: CustomLoader(color: Theme.of(context).primaryColor)) : CustomButton(
                      buttonText: getTranslated('submit', context),
                      onPressed: (){
                        if(paymentByController.text.isEmpty){
                          showCustomSnackBar(getTranslated('please_insert_user_name', context), context);
                        }else if(transactionIdController.text.isEmpty){
                          showCustomSnackBar(getTranslated('please_input_transaction_id', context), context);
                        }else{
                          widget.callBack(widget.placeOrderBody.setOfflinePayment(
                            paymentBy: paymentByController.text,
                            transactionReference: transactionIdController.text,
                            paymentNote: paymentNoteController.text,
                          ));
                        }
                      },
                    );
                  }
                )),
              ])

            ]
        ),
      ),
    );
  }
}