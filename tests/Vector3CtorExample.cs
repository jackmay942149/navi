using UnityEngine;
public class Vector3CtorExample : MonoBehaviour {
  Vector3 m_YDirectionVector;
  Rigidbody m_Rigidbody;
  float m_Speed = 2.0f;
  void Start() {
    m_YDirectionVector = new Vector3(0.0f, 1.0f, 0.0f);
    m_Rigidbody = GetComponent<Rigidbody>();
  }
  void Update() {
    m_Rigidbody.linearVelocity = m_YDirectionVector * m_Speed;
  }
}
