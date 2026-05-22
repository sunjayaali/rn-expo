import * as Device from "expo-device";
import { Link } from "expo-router";
import { Button, Platform, StyleSheet, Text, View } from "react-native";

export default function Index() {
  return (
    <View style={styles.container}>
      <Button
        title="Press me"
        onPress={() => {
          alert("Hello, world!");
        }}
      />
      <Text>My App</Text>
      <Text>{Platform.OS}</Text>
      <Text>{Device.modelName}</Text>
      <Text>{Device.brand}</Text>
      <Text>{Device.osVersion}</Text>
      <Link href={"/screen1"}>Screen1</Link>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "center",
    // justifyContent: "center",
  },
});
