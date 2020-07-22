using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class MutiSreen : MonoBehaviour
{
    // Start is called before the first frame update
    public GameObject water;
    public GameObject bg;
    public List<GameObject> clouds;
    float ratio;
    float aim = 0;
    Vector3 reset;
    void Start()
    {
        aim = clouds[0].GetComponent<RectTransform>().localPosition.x - this.GetComponent<RectTransform>().sizeDelta.x / 2;
        for (int i = 1; i < 3; i++)
        {
            clouds[i].GetComponent<RectTransform>().localPosition = new Vector3(clouds[i - 1].GetComponent<RectTransform>().localPosition.x + this.GetComponent<RectTransform>().sizeDelta.x / 2, clouds[i - 1].GetComponent<RectTransform>().localPosition.y, 0);
        }
        reset = clouds[2].GetComponent<RectTransform>().localPosition;
    }

    // Update is called once per frame
    void Update()
    {
        foreach(GameObject tmp in clouds)
        {
            tmp.GetComponent<RectTransform>().localScale = new Vector3(this.GetComponent<RectTransform>().sizeDelta.x / 2 / 1024, this.GetComponent<RectTransform>().sizeDelta.x / 2 / 1024, 1);
            Vector3 Target = new Vector3(aim, clouds[0].GetComponent<RectTransform>().localPosition.y, 0);
            tmp.GetComponent<RectTransform>().localPosition = Vector3.MoveTowards(tmp.GetComponent<RectTransform>().localPosition, Target, 0.2f);
            if (tmp.GetComponent<RectTransform>().localPosition.x == aim)
            {
                tmp.GetComponent<RectTransform>().localPosition = reset;
            }
        }
        ratio = this.GetComponent<RectTransform>().sizeDelta.x / this.GetComponent<RectTransform>().sizeDelta.y;
        water.GetComponent<RectTransform>().localScale=new Vector3(720*ratio/1.788f+140*(1.788f-ratio), 720 * ratio / 1.788f + 140 * (1.788f - ratio), 1);
        bg.GetComponent<RectTransform>().localScale = new Vector3(1.1f * ratio / 1.78f + 0.37f * (1.78f - ratio), 1.1f * ratio / 1.78f + 0.37f * (1.78f - ratio), 1);
    }
}
