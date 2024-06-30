import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../../A_SQL_Trigger/Con_Usermast.dart';

class Mail{
 static PaymentMail() async {

    String username = 'donlevi232@gmail.com';
    String password = 'izqkfebjfgyxnfzt';
    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'SnepiTech')
      ..recipients.add(Constants_Usermast.email.toString())
      ..subject = 'Attendy'
      ..text = ''' 
      Dear subscriber,

      Thank you, for subscribe Attendy this mail to inform you that your subscription
      date is 01-08-2023 to 01-08-2024 and your invoice number #ST20238-2 ''';

    try {
      final sendReport = await send(message, smtpServer);
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
}
}