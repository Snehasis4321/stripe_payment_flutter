import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_payment_flutter/payment.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'USD';

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        // convert string to double
          amount: (int.parse(amountController.text)*100).toString(),
          currency: selectedCurrency,
          name: nameController.text,
          address: addressController.text,
          pin: pincodeController.text,
          city: cityController.text,
          state: stateController.text,
          country: countryController.text);


      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image(
              image: AssetImage("assets/image.jpg"),
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
        hasDonated? Padding(padding: const EdgeInsets.all(8.0),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Thanks for your ${amountController.text} $selectedCurrency donation",
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "We appreciate your support",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 16,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.shade400),
                child: Text(
                  "Donate again",
                  style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                onPressed: () {
                  setState(() {
                    hasDonated = false;
                    amountController.clear();
                  });
                },
              ),
            ),
          ],
        ),
        ) :

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Support us with your donations",
                        style:
                            TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: ReusableTextField(
                                formkey: formkey,
                                controller: amountController,
                                isNumber: true,
                                title: "Donation Amount",
                                hint: "Any amount you like"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          DropdownMenu<String>(
                            inputDecorationTheme: InputDecorationTheme(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 0),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            initialSelection: currencyList.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                selectedCurrency = value!;
                              });
                            },
                            dropdownMenuEntries: currencyList
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ReusableTextField(
                        formkey: formkey1,
                        title: "Name",
                        hint: "Ex. John Doe",
                        controller: nameController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ReusableTextField(
                        formkey: formkey2,
                        title: "Address Line",
                        hint: "Ex. 123 Main St",
                        controller: addressController,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: ReusableTextField(
                                formkey: formkey3,
                                title: "City",
                                hint: "Ex. New Delhi",
                                controller: cityController,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              flex: 5,
                              child: ReusableTextField(
                                formkey: formkey4,
                                title: "State (Short code)",
                                hint: "Ex. DL for Delhi",
                                controller: stateController,
                              )),
                        ],
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: ReusableTextField(
                                formkey: formkey5,
                                title: "Country (Short Code)",
                                hint: "Ex. IN for India",
                                controller: countryController,
                              )),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              flex: 5,
                              child: ReusableTextField(
                                formkey: formkey6,
                                title: "Pincode",
                                hint: "Ex. 123456",
                                controller: pincodeController,
                                isNumber: true,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent.shade400),
                          child: Text(
                            "Proceed to Pay",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () async {
                            if (formkey.currentState!.validate() &&
                                formkey1.currentState!.validate() &&
                                formkey2.currentState!.validate() &&
                                formkey3.currentState!.validate() &&
                                formkey4.currentState!.validate() &&
                                formkey5.currentState!.validate() &&
                                formkey6.currentState!.validate()) {
  await initPaymentSheet();

  try{
    await Stripe.instance.presentPaymentSheet();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text(
        "Payment Done",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.green,
    ));

    setState(() {
      hasDonated=true;
    });
    nameController.clear();
    addressController.clear();
    cityController.clear();
    stateController.clear();
    countryController.clear();
    pincodeController.clear();

  }catch(e){
    print("payment sheet failed");
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
      content: Text(
        "Payment Failed",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.redAccent,
    ));
  }

                            }
                          },
                        ),
                      )
                    ])),
          ],
        ),
      ),
    );
  }
}
