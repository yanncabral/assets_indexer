import 'package:mustache/mustache.dart';

const String GeneratorComment = '''
/// This code is generated. DO NOT edit by hand
''';

const String _MustacheTemplate = '''
{{{generatorComment}}}

import 'package:flutter/painting.dart';

{{#stringClasses}}
class {{className}} {
  {{#keys}}
  static ImageProvider {{propertyName}} = const AssetImage(
        "{{propertyValue}}",
        package: "transfero_assets",
      );
  {{/keys}}
}
{{/stringClasses}}
''';

String getStringKeysCodeFromMap(Map<dynamic, dynamic> sourceMap) {
  final template = Template(_MustacheTemplate, htmlEscapeValues: false);
  final classInfos = [];
  for (var viewKey in sourceMap.keys) {
    var classMap = sourceMap[viewKey] as Map;
    var classProperties = classMap.keys
        .map(
          (propertyKey) => PropertyInfo(
            propertyName: propertyKey,
            propertyValue: classMap[propertyKey],
          ),
        )
        .toList();
    var info = StringsClassInfo(className: viewKey, keys: classProperties);
    classInfos.add(info);
  }

  var output = template.renderString({
    'generatorComment': GeneratorComment,
    'stringClasses': classInfos,
  });
  return output;
}

class StringsClassInfo {
  final String? className;
  final List<PropertyInfo>? keys;

  StringsClassInfo({this.className, this.keys});
}

class PropertyInfo {
  final String? propertyName;
  final String? propertyValue;

  PropertyInfo({this.propertyName, this.propertyValue});
}
