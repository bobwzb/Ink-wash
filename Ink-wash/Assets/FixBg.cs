using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FixBg : MonoBehaviour
{
    public GameObject bg;
    // Start is called before the first frame update
    void Start()
    {
        if (this.GetComponent<RectTransform>().sizeDelta.x/ this.GetComponent<RectTransform>().sizeDelta.y <1.5f)
        {
            Debug.Log("here");
            bg.GetComponent<RectTransform>().localScale = new Vector3(0.45f, 0.45f, 1);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
