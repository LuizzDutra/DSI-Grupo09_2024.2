import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class HomeController{

  static final GenerativeModel model = GenerativeModel(
      model: "gemini-2.0-flash",
      apiKey: dotenv.env["GEMINI_API_KEY"]!,
      systemInstruction: Content.text("Seu papel é ser um assistente de negócios pronto para tirar dúvidas dos seus clientes."));


  static void signOut(){
    FirebaseAuth.instance.signOut();
  }

  static Future<String> sendMessage(String message) async{
    var response = await model.generateContent([Content.text(message)]);
    String responseText = response.text ?? '';
    return responseText;
  }
}