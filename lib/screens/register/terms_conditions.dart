import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Provider/darkModd.dart';
import '../../constants/app_colors.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key key}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);

    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: darkModeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          elevation: 0,
          backgroundColor: darkModeProvider.isDarkMode
              ? AppColors.darkmood.withOpacity(0.7)
              : Colors.white,
          title: Text(
            "Terms & Conditions",
            style: TextStyle(
                color:
                    darkModeProvider.isDarkMode ? Colors.white : Colors.black),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color:
                darkModeProvider.isDarkMode ? AppColors.darkmood : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "General Terms ",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "By signing up with PlayPointz, you confirm that you are in agreement with and bound by the terms and conditions outlined below. These terms apply to any type of communication between you and PlayPointz.\n\nUnder no circumstances shall PlayPointz team be liable for any direct, indirect, special, incidental or sequential damages, including, but not limited to, loss of data given to the app, even if the PlayPointz team or an authorized representative has been advised of the possibility of such damages.\n\nPlayPointz can be used only by those who are above the age of 17 and will not be responsible for any outcome that may occur during the course of usage of our resources. We reserve rights to change Pointz and revise the resources usage policy at any moment.",
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Official Rules",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Users can sign up with this application everyday to collect “Daily Pointz”. In any case the user was unable to login to the app, the user will lose some amount of Pointz. Also users can answer a certain number of questions to earn Pointz. For every correct answer users will receive an amount of Pointz while for every incorrect answer they will lose an amount of Pointz. With the Pointz they collected, they can redeem the items given in the Store of the app.  \n\nTo redeem an item from the PlayPointz Store, the user must have enough number of Pointz as well as the user should wait until the item is activated. Users can redeem the item before it is “Timed Out”. Once the item is redeemed the item will be sent to the address given by the user through the delivery partner. We are not responsible for false addresses as well as the delays that can happen during the delivery. \n\nThe Apple Inc. Organization is not in partnership or does not support any method for this application and for the redeemable items",
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Official Rules",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'The terms and conditions that are shown in this agreement are a contract between you and PlayPointz grants you a revocable, non-exclusive, non-transferable, limited license to download, install and use the app strictly in accordance with the terms of this agreement.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Definitions and key terms",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text('For this Terms & Conditions:'),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Cache :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Small amount of data generated by an app and saved by your device. It is used to identify your device, provide analytics, and remember information about you such as your language preferences or login information.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Company:  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'When this policy mentions “Company”, ”we”, “us”, or “our”, it refers to PlayPointz, Sri Lanka that is responsible for your information under this Privacy Policy.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Country :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Where PlayPointz or the owners/founders of PlayPointz are based, in this case Sri Lanka.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Customer :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'refers to the company, organization or person that signs up to use the PlayPointz services to manage the relationships with users.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Device :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Any internet connected device such as, phone, tablet, computer or any other device that can be used to visit PlayPointz and use the service.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' IP Address :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Every device connected to the internet is assigned a number known as Internet Protocol (IP) address. These numbers are usually assigned in geographic blocks. An IP address can often be used to identify the location from which a device is connecting to the internet.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Personnel :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Refers to those individuals who are employed by PlayPointz or are under contract to perform a service on behalf of one of the parties.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Personal Data :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Any information that directly, indirectly, or in connection with other information - including personal identification number - allows for the identification of a person.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Service :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Refers to the service provided by PlayPointz as described in the relative terms (if available) and on this platform.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Third-party service :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                          text:
                              'Refers to advertisers, contest sponsors, promotional and marketing partners, and others who provide our contest or whose products or services we think may interest you. ',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' Website :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'PlayPointz’s site which can be accessed via this URL www.playpointz.com'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle_rounded,
                            size: 8.sp,
                          ),
                        ),
                        TextSpan(
                            text: ' You :  ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text:
                                'A person or entity that is registered with PlayPointz to use the service.'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Restrictions",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 16,
                  ),
                  Text('You agree not to, and you will not permit others to;'),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(
                              Icons.circle_rounded,
                              size: 8.sp,
                            ),
                          ),
                        ),
                        TextSpan(
                          text:
                              ' License, sell, rent, lease, assign, distribute, transmit, host, outsource, disclose or otherwise commercially exploit the service to make the platform available to any third party.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 3.0),
                            child: Icon(
                              Icons.circle_rounded,
                              size: 8.sp,
                            ),
                          ),
                        ),
                        TextSpan(
                          text:
                              ' Modify, make derivative works of, disassemble, decrypt, reverse compile or reverse engineer any part of this service.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Icon(
                              Icons.circle_rounded,
                              size: 8.sp,
                            ),
                          ),
                        ),
                        TextSpan(
                          text:
                              ' Remove, alter or obscure any proprietary notice (including any notice or copyright or trademark) of or its affiliate, partners, suppliers or the licensors of the service.',
                          style: TextStyle(
                              color: darkModeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(' Return Policy',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We appreciate the fact that you like to join the PlayPointz team. We also want to make sure you have a rewarding experience while you are exploring, evacuating and using our application. \n As with any app experience, there are terms and conditions that apply for the users. The main thing to remember is that by signing up to our app, you agree to terms along with our Privacy Policy. \n According to these Terms & Conditions we claim that we are not responsible for returning any of the items that the users have redeemed in any case. In addition, we do not provide any kind of warranty to any of the products that you redeem from PlayPointz.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Your Suggestions',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Any feedback, comment, idea, improvement or suggestions provided by you to us with respect to the service shall remain the sole and exclusive property of us. We shall be free to use, copy, modify, publish, or redistribute the suggestions for any purpose and in any way without any credit or any compensation to you. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Any feedback, comment, idea, improvement or suggestions provided by you to us with respect to the service shall remain the sole and exclusive property of us. We shall be free to use, copy, modify, publish, or redistribute the suggestions for any purpose and in any way without any credit or any compensation to you. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Your Consent',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We’ve updated our Terms & Conditions to provide you with complete transparency into what is being set when you visit our app and how it\'s being used. By using our service, registering an account, or redeeming an item, you hereby consent to our Terms & Conditions.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Advertisements',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      'Our app may contain advertisements from such clients who are sponsoring to PlayPointz in which they are already granted permissions to publish their promotions and advertisements. On the other hand there will be third party ads which are also from the sponsors of PlayPointz.'),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Cookies ',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We use “Cookies'
                    ' to identify the areas of our app that you have visited. A cookie is a small piece of data stored on your computer or mobile device by your web browser. We use cookies to enhance the performance and functionality of our service but are non essential to their use. However, without these cookies, certain functionality like videos may become unavailable or you would be required  to enter your login details every time you visit our platform as we would not be able to remember that you had logged in previously. Most web browsers can be set to disable the use of cookies. However, if you disable cookies, you may not be able to access functionality on our app correctly or at all. We never place personally identifiable information in cookies.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Change of our Terms & Conditions'),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'You acknowledge and agree that we may stop (permanently or temporarily) providing the service to you or to users generally at our sole discretion, without prior notice to you. You may stop using the app any time. You do not need to specifically inform us when you stop using the app. You acknowledge and agree that if we disable access to your account, you may be prevented from accessing the app, your account details or any files or other materials which are contained in your account. If we decide to change our Terms & Conditions, we will post those changes on this page and/ or update the Terms & Conditions modification below. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Modification to our service',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We reserve the  right to modify, suspend or discontinue, temporarily or permanently, the service or any service to which it connects, with or without notice and without liability to you. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Updates to our service',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We may from time to time provide enhancement or improvement to the failures/ functionality of the service, which may include patches, bug files, updates, upgrades, and other modifications (updates). Updates may modify or delete certain features and/or functionalities of the service. You agree that we have no obligation to (i) provide any updates, or (ii) continue to provide or enable any particular features and/or functionalities and/or functionalities of the service to you. You further agree that all updates  will be (i) deemed to constitute an integral part of the service, and (ii) subject to terms and conditions of the agreement. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Term and Termination',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'This agreement shall remain in effect until terminated by you or us. We may, in its sole discretion, at any time and for any or no reason, suspend or terminate this agreement with or without prior notice. This agreement will terminate immediately, without prior notice from us, in the event that you fail to comply with any provision of this agreement. You may also terminate this agreement by deleting the service and all copies of thereof from your computer. Upon termination of this agreement, you shall cease all use of the service and delete all copies of the service from your computer. Termination of this agreement will not limit any of our rights or remedies at law or in equity in case of breach by you of any of your obligations under the present agreement.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Copyright infringement notice',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'If you are a copyright owner or such owner’s agent and believe any material from us constitute an infringement on your copyright, please contact us setting forth the following information: (a) a physical or electronic signature of the copyright owner or a person authorized to act on his behalf; (b) identification of the material that is claimed to be infringing; (c) your contact information, including your address, telephone number, and an email; (d) a statement that the information in the notification is accurate, and, under penalty of perjury you are authorized to act on behalf of the owner.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Indemnification ',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'You agree to indemnify and hold us and our subsidiaries, affiliates, officers, employees, agents, partners, relations and licensors (if any) harmless from any claim or demand, including reasonable attorney’s fees, due to arising out of your: (a) use of the service; (b) violation of this agreement or any law or regulation; or (c) violation of any right of a third party. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('No Warranties',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'The service is provided to you “AS IS” and “AS AVAILABLE” and with all faults and defects without warranty of any kind. To the maximum extent permitted under applicable law, we on our own behalf and on behalf of our affiliate and our respective licensors and service providers, expressly disclaims all warranties, whether express, implied, statutory or otherwise, with respect to the service, including all implied warranties of merchantability, fitness for a particular purpose, title and non-infringement, and warranties that may arise out of course of dealing, course of performance, usage or trade practice. Without limitation for the foregoing, we provide no warranty or undertaking, and makes no representation of any kind that the service will meet your requirements, achieve any intended results, be compatible or work with any other software, websites, systems or services, operate without interruption, meet any performance or reliability standards or be error free or that any errors or defects can or will be corrected. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Without limiting the foregoing, neither us nor any provider makes any representation or warranty of any kind, express or implied: (i) as to the operation or availability of the service, or the information, content, and materials or products included thereon; (ii) that the service will be uninterrupted or error free; or (iii) that the service, its servers, the content, or emails sent from or on behalf of us are free of viruses, scripts, trojan horses, worms, malware, timebombs or other harmful components. Some jurisdictions do not allow the execution of or limitations on implied warranties or the limitations on the applicable statutory rights of a consumer, so some or all the above exclusions and limitations may not apply to you.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Limitations and Liability',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Notwithstanding any damages that you might incur, the entire liability of us and any of our sponsors under any provision of this agreement and your exclusive remedy for all of the foregoing shall be limited. To the maximum extent permitted by applicable law, in no event shall we and our sponsors be liable for any special, incidental, indirect, or consequential damages whatsoever (including, but not limited to, damages or loss of profits, for loss of data or other information, for business interruption, for loss of privacy arising out of or in any way related to the use of or inability to use to the service, third-party software and or third-party hardware used with the service, or otherwise in connection with any provision of this agreement),SizedBox(height: 16,) even if we or any sponsor has been advised of the possibility of such damages and even if the ,remedy fails of its essential purpose.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Severability',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      'If any provision of this agreement is held to be unenforceable or invalid, such provision will be changed and interpreted to accomplish the objectives of such provision to the greatest extent possible under applicable law and the remaining provisions will continue  in full force and effect.'),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'This agreement, together with the Privacy Policy and any other legal notices published by us on the services, shall constitute the entire agreement between you and us concerning the services. If any provision of this agreement is deemed invalid by a court of competent jurisdiction, the invalidity of such provision shall not affect the validity of the remaining provisions of this agreement, which shall remain in full force and effect. No waiver of any term of this agreement shall be deemed a further or continuing  waiver of such term or any other term, and our failure to assert any right or provision under this agreement shall not constitute a waiver of such right or provision. You and us agree that any cause of action arising out of or related to the services must commence within one (1) year after the cause of action occurred. Otherwise, such cause of action is permanently barred. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Amendments to this Agreement',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We reserve the right, at its sole discretion, to modify or replace this agreement at any time. If a revision is material, we will provide at least 30 days’ notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion. By continuing to access or use our service after any revisions become effective, you agree to be bound by the revised terms. If you do not agree to the new terms, you are no longer authorized to use our services.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Entire agreement',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'The agreement constitutes the entire agreement between you and us regarding your use of the service and supersedes all prior and contemporaneous written or oral agreement between you and us. You may be subject to additional terms and conditions that apply when you use or redeem items from us, which we will provide to you at the time of such case.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'The agreement constitutes the entire agreement between you and us regarding your use of the service and supersedes all prior and contemporaneous written or oral agreement between you and us. You may be subject to additional terms and conditions that apply when you use or redeem items from us, which we will provide to you at the time of such case.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'The agreement constitutes the entire agreement between you and us regarding your use of the service and supersedes all prior and contemporaneous written or oral agreement between you and us. You may be subject to additional terms and conditions that apply when you use or redeem items from us, which we will provide to you at the time of such case.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'The agreement constitutes the entire agreement between you and us regarding your use of the service and supersedes all prior and contemporaneous written or oral agreement between you and us. You may be subject to additional terms and conditions that apply when you use or redeem items from us, which we will provide to you at the time of such case.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'The agreement constitutes the entire agreement between you and us regarding your use of the service and supersedes all prior and contemporaneous written or oral agreement between you and us. You may be subject to additional terms and conditions that apply when you use or redeem items from us, which we will provide to you at the time of such case.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Updates to our terms',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We may change our service and policies, and we may need to make changes to these terms so that they accurately reflect our service and policies. Unless otherwise required by law, we will notify you (for example, through our service) before we make changes to these terms and give you an opportunity to review them before they go into effect. Then, if you continue to use the service, you will be bound by the updates terms. If you do not want to agree to these or any update terms, you can delete your account.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Intellectual property',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Our platform and its entire contents, features and functionality (including but not limited to all information, software, text, displays, images, video and audio, and the design, selection and arrangement thereof),SizedBox(height: 16,) are owned by ,us, its licensors or other providers of such material and are protected by Sri Lanka and international copyright, trademark, patent, trade secret and other intellectual property or proprietary rights laws. The materials may not be copied, modified, reproduced, downloaded or distributed in any way, in whole or in part, without the express prior written permission of us, unless and except as is expressly provided in these Terms & Conditions. Any authorized use of the material is prohibited.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Agreement to arbitrate'),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'This section applies to any dispute except it does not include a dispute relating to claims for injunctive or equitable relief regarding the enforcement or validity of your or PlayPointz’s intellectual property rights. The term “dispute” means any dispute, action, or other controversy between you and us concerning the services or this agreement, whether in contract, warranty, tort, statute, regulation, ordinance, or any other legal or equitable basis. “Dispute” will be given the broadest possible meaning allowable under law.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Notice of Dispute'),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'In the event of dispute, you or us must give the other a Notice of Dispute, which is a written statement that sets forth the name, address, and contact information of the party giving it, that facts giving rise to the dispute, and the relief requested.  You must send any Notice of Dispute via email to legal@playpointz.com You and us will attempt to resolve any dispute through informal negotiation within sixty (60) days from the date the Notice of Dispute is sent. After sixty (60) days, you or us may commence arbitration.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Binding Arbitration'),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'If you and us don’t resolve any dispute by informal negotiation, any other effort to resolve the dispute will be conducted exclusively by binding arbitration as described in this section. You are giving up the right to litigate (or participate in as a party or class member) all disputes in court before a judge or jury. The dispute shall be settled by binding arbitration in accordance with the commercial arbitration rules of the Sri Lankan Court Order. Either party may seek any interim or preliminary injunctive relief from any court of competent jurisdiction, as necessary to protect the party’s rights or property pending the completion of arbitration. Any and all legal, accounting, and other costs, fees, and expenses incurred by the prevailing party shall be borne by the non-prevailing party. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Submissions and Privacy',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'In the event that you submit or post any ideas, creative suggestions, designs, photographs, information, data or proposals, including ideas for new or improved products , services, features, technologies or promotions, you expressly agree that such submissions will automatically be treated as non-confidential and non-proprietary and will become the sole property of us without any compensation or credit to you whatsoever. We and our affiliates shall have no obligation with respect to such submissions or posts and may use the ideas contained in such submissions or posts for any purposes in any medium in perpetuity.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Promotions',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We may, from time to time, include contests, promotions, sweepstakes, or other activities (Promotions) that require you to submit material or information concerning yourself. Please note that all events may be governed by separate rules that may contain certain eligibility requirements, such as restrictions as to age and geographic location. You are responsible to read all promotion rules to determine whether or not you are eligible to participate. If you enter any Promotions, you agree to abide by and to comply with all Promotions rules. Additional terms and conditions may apply to redeeming of goods or services on or through the app, which terms and conditions are made a part of this agreement by this reference.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Typographical Errors',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'In the event a product and/or service is listed at an incorrect number of Pointz or with incorrect information due to typographical error, we shall have the right to refuse or cancel any orders placed for the product and/or service listed at the incorrect number of Pointz. If you have already been charged by Pointz for the redeem and your order is canceled, we shall immediately issue Pointz to your account in the amount of the charge.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Miscellaneous',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'If for any reason a court of competent jurisdiction finds any provision and/or portion of these Terms & Conditions to be unenforceable, the remainder of these Terms & Conditions will continue in full force and effect. Any waiver of any provision of these Terms & Conditions will be effective only if in writing and signed by an authorized representative of us. We will be entitled to injunctive or other equitable relief (without the obligations of posting any bond or surety) in the event of any breach or anticipatory breach by you. We operate and control our service from our offices in Sri Lanka. The service is not intended for distribution to or use by any person or entity in any jurisdiction or country where such distribution or use would be contrary to law or regulation. Accordingly, those persons who choose to access our service from other locations do so on their own initiatives and are solely responsible for compliance with local laws, if and to the extent local laws are applicable. These Terms & Conditions (which include and incorporate our Privacy Policy) contains the entire understanding, and supersedes all prior understandings, between you and us concerning its subject matter, and cannot be changed or modified by you. The section headings used in this agreement are for convenience only and will not be given any legal import.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Disclaimer',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'We are not responsible for any content or any other imprecision. We do not provide warranties or guarantees. In no event shall we be liable for any special, direct, indirect, consequential, or incidental damages or any damages whatsoever, whether in an action of contract, negligence  or other tort, arising out of or in connection with the use of the service or the contents of the service. We reserve the right to make additions, deletions, or modifications to the contents on the service at any time without prior notice.',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Our service and its contents are provided “as is“ and “as available” without any warranty or representations of any kind, whether express or implied. We are a distributor and not a publisher of the content supplied by third parties; as such, our exercises no editorial control over such content and makes no warranty or representation as to the accuracy, reliability or currency of any information, content, service or merchandise provided through or accessible via our service. Without limiting the foregoing, we specifically disclaim  all warranties and representations in any content transmitted on or in connection with our service or on sites that may appear as links on our service, or in the products provided as a part of, or otherwise in connection with, our service, including without any limitation any warranties of merchantability, fitness for a particular purpose or non-infringement of third party rights. No oral advice or written information given by us or any of its affiliates, employees, officers, directors, agents, or the like will create a warranty. Price and availability information is subject to change without notice. Without limiting the foregoing, we do not warrant that our service will be uninterrupted, uncorrupted, timely, or error-free. ',
                    style: TextStyle(
                        color: darkModeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Delivery Terms',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      'After purchase an item using points, it will be received within 1 to 14 days.',),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Eligibility",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                      "Effective from November 1, 2023, outlines the requirements to qualify as a redeemed winner: Ensure your PlayPointz account is fully completed, including your photo, full name, address, and phone number,Your account name must correspond to the information on your National ID card.The PlayPointz team may request your National ID card or an official identity certificate for identity verification,Alternatively, you may opt to provide a certified utility bill to confirm your residency."),
                  SizedBox(
                    height: 16,
                  ),
                  Text('Contacts',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text('Suggestions/Requests: ',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        TextSpan(text: 'suggest@playpointz.com '),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text('Business Development: ',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        TextSpan(text: 'business@playpointz.com '),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text('Legal: ',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        TextSpan(text: ' legal@playpointz.com'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 0.0),
                            child: Text('Advertising: ',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                        TextSpan(text: ' advertise@playpointz.com	'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
