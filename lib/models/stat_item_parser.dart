import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/remote_stat_item.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/provider/stat_item_provider.dart';

const SPLIT_CHAR = ';';

extension StatItemListExt on List<StatItem> {
  Map<String, StatItem> toKeyTypeMap() {
    Map<String, StatItem> keyTypeMap = Map();
    for (final item in this) keyTypeMap[item.key] = item;
    return keyTypeMap;
  }
}

extension ParseFirestoreData on Map<String, dynamic> {
  StatItem toStatItem() {
    return RemoteStatItem.fromFirestoreData(this).toStatItem();
  }
}

extension ParseRemoteItem on RemoteStatItem {
  Map<String, dynamic> toFirestoreData() {
    String choicesString;
    if (choices != null) {
      choicesString = '';
      choices.forEach((element) => choicesString += '$element$SPLIT_CHAR');
      //If the string is not empty then we remove the last split character
      if (choicesString.length > 0)
        choicesString.substring(0, choicesString.length - 1);
    } else
      choicesString = null;

    return <String, dynamic>{
      StatItemField.type.label: type,
      StatItemField.key.label: key,
      StatItemField.user_email.label: userEmail,
      StatItemField.is_custom.label: isCustom,
      StatItemField.is_enabled.label: isEnabled,
      StatItemField.localized_label.label: localizedLabel,
      StatItemField.display_in_list.label: displayInList,
      StatItemField.input_label.label: inputLabel,
      StatItemField.output_label.label: outputLabel,
      StatItemField.color.label: color.value,
      StatItemField.position.label: position,
      StatItemField.min.label: min,
      StatItemField.max.label: max,
      StatItemField.name.label: name,
      StatItemField.max_length.label: maxLength,
      StatItemField.max_length.label: maxLength,
      StatItemField.type.label: type,
      StatItemField.halfRating.label: halfRating,
      StatItemField.choices.label: choicesString,
    };
  }

  StatItem toStatItem() {
    switch (type) {
      case 'PictureStatItem':
        return PictureStatItem(
          key: key,
          userEmail: userEmail,
        );
      case 'MoodStatItem':
        return MoodStatItem(
          key: key,
          userEmail: userEmail,
        );
      case 'ProductivityStatItem':
        return ProductivityStatItem(
          key: key,
          userEmail: userEmail,
        );
      case 'CommentStatItem':
        return CommentStatItem(
          key: key,
          userEmail: userEmail,
        );
      case 'QuantityStatItem':
        return QuantityStatItem(
          key: key,
          userEmail: userEmail,
          isCustom: isCustom,
          isEnabled: isEnabled,
          localizedLabel: localizedLabel,
          displayInList: displayInList,
          inputLabel: inputLabel,
          outputLabel: outputLabel,
          color: color,
          position: position,
          min: min,
          max: max,
          halfRating: halfRating,
          name: name,
        );
      case 'TextStatItem':
        return TextStatItem(
            key: key,
            userEmail: userEmail,
            isCustom: isCustom,
            isEnabled: isEnabled,
            localizedLabel: localizedLabel,
            displayInList: displayInList,
            inputLabel: inputLabel,
            outputLabel: outputLabel,
            color: color,
            position: position,
            name: name,
            maxLength: maxLength);
      case 'McqStatItem':
        return McqStatItem(
            key: key,
            userEmail: userEmail,
            isCustom: isCustom,
            isEnabled: isEnabled,
            localizedLabel: localizedLabel,
            displayInList: displayInList,
            inputLabel: inputLabel,
            outputLabel: outputLabel,
            color: color,
            position: position,
            name: name,
            choices: choices);
      default:
        return null;
    }
  }
}

extension ParseStatItem on StatItem {
  RemoteStatItem _toRemoteItem() {
    double min;
    double max;
    List<String> choices;
    int maxLength;
    bool halfRating;

    if (this is QuantityStatItem) {
      QuantityStatItem quantityStatItem = this as QuantityStatItem;
      min = quantityStatItem.min;
      max = quantityStatItem.max;
      halfRating = quantityStatItem.halfRating;
    } else if (this is TextStatItem) {
      TextStatItem textStatItem = this as TextStatItem;
      maxLength = textStatItem.maxLength;
    } else if (this is McqStatItem) {
      McqStatItem mcqStatItem = this as McqStatItem;
      choices = mcqStatItem.choices;
    }
    return RemoteStatItem(
        key: key,
        userEmail: userEmail,
        isCustom: isCustom,
        isEnabled: isEnabled,
        localizedLabel: localizedLabel,
        displayInList: displayInList,
        inputLabel: inputLabel,
        outputLabel: outputLabel,
        color: color,
        position: position,
        min: min,
        max: max,
        choices: choices,
        maxLength: maxLength,
        name: name,
        halfRating: halfRating,
        type: this.runtimeType.toString()
    );
  }

  Map<String, dynamic> toFirestoreData() =>
      this._toRemoteItem().toFirestoreData();
}

List<StatItem> parseStatItems(List<DocumentSnapshot> documents) {
  return documents.map((DocumentSnapshot document) {
    return document.data.toStatItem();
  }).toList();
}
