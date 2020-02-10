import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dpa/models/remote_stat_item.dart';
import 'package:dpa/models/stat_item.dart';
import 'package:dpa/provider/stat_item_provider.dart';

const SPLIT_CHAR = ';';

extension ParseFirestoreData on Map<String, dynamic>  {
  StatItem toStatItem() {
    return RemoteStatItem.fromFirestoreData(this).toStatItem();
  }
}
extension ParseRemoteItem on RemoteStatItem {
  Map<String, dynamic> toFirestoreData() {
    String choicesString = '';
    if (choices != null) {
      choices.forEach((element) => choicesString += '$element$SPLIT_CHAR');
      //If the string is not empty then we remove the last split character
      if (choicesString.length > 0)
        choicesString.substring(0, choicesString.length - 1);
    } else
      choicesString = null;

    return <String, dynamic>{
      StatItemField.type.label: type,
      StatItemField.key.label: key,
      StatItemField.userEmail.label: userEmail,
      StatItemField.isCustom.label: isCustom,
      StatItemField.isEnabled.label: isEnabled,
      StatItemField.localizedLabel.label: localizedLabel,
      StatItemField.displayInList.label: displayInList,
      StatItemField.inputLabel.label: inputLabel,
      StatItemField.outputLabel.label: outputLabel,
      StatItemField.color.label: color.value,
      StatItemField.position.label: position,
      StatItemField.min.label: min,
      StatItemField.max.label: max,
      StatItemField.maxLength.label: maxLength,
      StatItemField.choices.label: choicesString,
    };
  }

  StatItem toStatItem() {
    switch (type) {
      case 'PictureStatItem':
        return PictureStatItem(
          userEmail: userEmail,
        );
      case 'MoodStatItem':
        return MoodStatItem(
          userEmail: userEmail,
        );
      case 'ProductivityStatItem':
        return ProductivityStatItem(
          userEmail: userEmail,
        );
      case 'CommentStatItem':
        return CommentStatItem(
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
    if (this is QuantityStatItem) {
      QuantityStatItem quantityStatItem = this as QuantityStatItem;
      min = quantityStatItem.min;
      max = quantityStatItem.max;
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
        type: this.runtimeType.toString());
  }

  Map<String, dynamic> toFirestoreData() =>
      this._toRemoteItem().toFirestoreData();
}

List<StatItem> parseStatItems(List<DocumentSnapshot> documents) {
  return documents.map((DocumentSnapshot document) {
    return document.data.toStatItem();
  }).toList();
}