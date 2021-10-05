import QtQuick 2.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Component {
  id: variable_element;

  ColumnLayout {

    width: parent.width;
    RowLayout { // Key
      width: parent.width;
      visible: var_type_input.currentIndex === 9;
      Label {text: "Key: "}
      ComboBox {
        id: key_type_input;
        Layout.fillWidth: true;
        model: [
          "byte_array",
          "word_array",
          "dword_array",
          "qword_array"
        ];
        currentIndex: (typeof(key_type) == "string") ? indexOfValue(key_type): 0;
      }
    } // Key

    RowLayout { // Value
      width: parent.width;

      Label {text: "Value: "}

      ComboBox {
        id: value_type_input;
        Layout.fillWidth: true;
        model: [
          "byte",
          "word",
          "dword",
          "qword",
          "byte_array",
          "word_array",
          "dword_array",
          "qword_array",
          "array",
          "object"
        ];

        onCurrentTextChanged: {
          element_model.setProperty(index, "type", currentText);
        }
        Component.onCompleted: {
          currentIndex = indexOfValue(element_model.get(index).type);
        }
      }

      TextField {
        id: value_input
        Layout.fillWidth: true;
        visible: false;
        validator: IntValidator {
          id: element_value_validator;
        }
        text: (typeof(value) == "numeber" || typeof(value) == "string")? value : 0;
        onTextChanged: {
          if(value_type_input.currentIndex == 4)
            element_model.setProperty(index, "value", text);
          else
            element_model.setProperty(index, "value", text-1+1);
        }
        Component.onCompleted: {
          let value = element_model.get(i).value;
          if(value) text = value;
        }
      }

      ToolButton {
        id: edit_button;
        icon.source: "qrc:/icons/icons/edit_white_24dp.svg";
        onClicked: editor_win.push(index);
      }

      states: [
        State {
          name: "byte_state"
          when: value_type_input.currentIndex == 0;
          PropertyChanges {target: edit_button; visible: false;}
          PropertyChanges {target: value_input; visible: true; placeholderText: "-128...255"}
          PropertyChanges {target: element_value_validator; bottom: -128; top: 255;}
        },

        State {
          name: "word_state"
          when: value_type_input.currentIndex == 1;
          PropertyChanges {target: edit_button; visible: false;}
          PropertyChanges {target: value_input; visible: true; placeholderText: "-32768...65535"}
          PropertyChanges {target: element_value_validator; bottom: -32768; top: 65535;}
        },

        State {
          name: "dword_state"
          when: value_type_input.currentIndex == 2;
          PropertyChanges {target: edit_button; visible: false;}
          PropertyChanges {target: value_input; visible: true; placeholderText: "-2147483648...4294967295"}
          PropertyChanges {target: element_value_validator; bottom: -2147483648; top: 4294967295;}
        },

        State {
          name: "qword_state"
          when: value_type_input.currentIndex == 3;
          PropertyChanges {target: edit_button; visible: false;}
          PropertyChanges {target: value_input; visible: true; placeholderText: "-9223372036854775808...18446744073709551615"}
          PropertyChanges {target: element_value_validator; bottom: -9223372036854775808; top: 18446744073709551615;}
        }
      ]

    } // Value


    RowLayout {
      ToolButton {
        icon.source: "qrc:/icons/icons/add_circle_white_24dp.svg";
        onClicked: {
          element_model.addElement(index);
        }
      }

      ToolButton {
        text: "Add first";
        visible: !index;
        onClicked: {
          element_model.addElement(0);
        }
      }

      ToolButton {
        icon.source: "qrc:/icons/icons/cancel_white_24dp.svg";
        onClicked: {
          element_model.removeElement(index);
        }
      }
    }


  }
}