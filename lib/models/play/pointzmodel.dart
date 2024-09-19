// To parse this JSON data, do
//
//     final pointzModel = pointzModelFromJson(jsonString);

import 'dart:convert';

PointzModel pointzModelFromJson(String str) => PointzModel.fromJson(json.decode(str));

String pointzModelToJson(PointzModel data) => json.encode(data.toJson());

class PointzModel {
    bool done;
    Body body;
    String message;

    PointzModel({
        this.done,
        this.body,
        this.message,
    });

    factory PointzModel.fromJson(Map<String, dynamic> json) => PointzModel(
        done: json["done"],
        body: Body.fromJson(json["body"]),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "done": done,
        "body": body.toJson(),
        "message": message,
    };
}

class Body {
    Body();

    factory Body.fromJson(Map<String, dynamic> json) => Body(
    );

    Map<String, dynamic> toJson() => {
    };
}
