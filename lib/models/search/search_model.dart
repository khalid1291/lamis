import 'dart:convert';

List<SearchSuggestionResponse> searchSuggestionResponseFromJson(String str) =>
    List<SearchSuggestionResponse>.from(
        json.decode(str).map((x) => SearchSuggestionResponse.fromJson(x)));

String searchSuggestionResponseToJson(List<SearchSuggestionResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SearchSuggestionResponse {
  SearchSuggestionResponse({
    required this.id,
    this.query,
    required this.count,
    this.type,
    required this.typeString,
  });

  int id;
  String? query;
  int count;
  String? type;
  String typeString;

  factory SearchSuggestionResponse.fromJson(Map<String, dynamic> json) =>
      SearchSuggestionResponse(
        id: json["id"],
        query: json["query"],
        count: json["count"],
        type: json["type"],
        typeString: json["type_string"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "query": query,
        "count": count,
        "type": type,
        "type_string": typeString,
      };
}
