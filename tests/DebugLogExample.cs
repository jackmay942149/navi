using UnityEngine;
public class DebugLogExample : MonoBehaviour {
  string Bar = "Hello, World!";
  void Awake() {
    Debug.Log(Bar);
  }
}
