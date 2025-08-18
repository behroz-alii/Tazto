import 'package:dart_openai/dart_openai.dart';
import 'package:tazto/services/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodAIService {
  static void initialize() {
    OpenAI.apiKey = Config.openAIKey;
    OpenAI.baseUrl = "https://api.openai.com/v1";
  }

  Future<String> handleQuery(String userQuery) async {
    try {
      // First try the direct API call
      try {
        final chatCompletion = await OpenAI.instance.chat.create(
          model: "gpt-3.5-turbo",
          messages: [
            OpenAIChatCompletionChoiceMessageModel(
              role: OpenAIChatMessageRole.system,
              content: [
                OpenAIChatCompletionChoiceMessageContentItemModel.text(
                  "You are Tazto Food Assistant. Help with: "
                      "- Order status\n- Menu questions\n- Dietary info\n"
                      "- Keep responses under 2 sentences. Be friendly and helpful.",
                ),
              ],
            ),
            OpenAIChatCompletionChoiceMessageModel(
              role: OpenAIChatMessageRole.user,
              content: [
                OpenAIChatCompletionChoiceMessageContentItemModel.text(userQuery),
              ],
            ),
          ],
          maxTokens: 150,
          temperature: 0.7,
        );

        final responseContent = chatCompletion.choices.first.message.content;

        // Convert any response type to String
        return _convertResponseToString(responseContent);
      } catch (e) {
        // Fallback to direct HTTP request if package fails
        return await _fallbackApiCall(userQuery);
      }
    } catch (e) {
      return "Error: Please try again later. If this persists, contact support.";
    }
  }

  String _convertResponseToString(dynamic responseContent) {
    if (responseContent == null) {
      return "No response received from the assistant.";
    }

    if (responseContent is String) {
      return responseContent;
    }

    if (responseContent is List<OpenAIChatCompletionChoiceMessageContentItemModel>) {
      // Extract text from all content items and join them
      return responseContent
          .map((item) => item.text)
          .where((text) => text != null)
          .join('\n')
          .trim();
    }

    return "Unexpected response format.";
  }

  Future<String> _fallbackApiCall(String query) async {
    try {
      final response = await http.post(
        Uri.parse("${OpenAI.baseUrl}/chat/completions"),
        headers: {
          'Authorization': 'Bearer ${Config.openAIKey}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content": "You are Tazto Food Assistant. Help with: "
                  "- Order status\n- Menu questions\n- Dietary info\n"
                  "- Keep responses under 2 sentences. Be friendly and helpful."
            },
            {
              "role": "user",
              "content": query
            }
          ],
          "max_tokens": 150,
          "temperature": 0.7
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? "No response content available.";
      } else {
        return "Server error: ${response.statusCode}";
      }
    } catch (e) {
      return "Connection failed. Please check your internet.";
    }
  }
}