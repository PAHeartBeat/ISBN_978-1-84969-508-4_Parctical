using UnityEngine;
using System.Collections;

public class ProceduralTexture : MonoBehaviour {
	private Texture2D runtimeTexure;

	private Material curMaterial;
	private Vector3 centerPosition; 

	public int TextureSize = 256;


	// Use this for initialization
	void Start () {
		if(!curMaterial){
			curMaterial = renderer.sharedMaterial;
			if(!curMaterial){
				Debug.LogError(name + " Object has not assigned any material");
			}
		}

		if(curMaterial){
			centerPosition = new Vector2(0.9f,0.5f);
			runtimeTexure = GenrateColorByAngle();

			curMaterial.SetTexture("_MainTex",runtimeTexure);
		}
	}
	
	// Update is called once per frame
	void Update () {
	}

	private Texture2D GenrateParabola(){
		Texture2D tx2d = new Texture2D(TextureSize,TextureSize);
		Vector2 centerPixel;
		centerPixel = centerPosition * TextureSize;


		for(int x = 0; x < TextureSize; x++) {
			for(int y = 0; y < TextureSize; y++) {
				Vector2 cp= new Vector3(x, y);
				float pixelDist = Vector2.Distance(cp, centerPixel) / (TextureSize * 0.5f);

				pixelDist = Mathf.Abs(1 - Mathf.Clamp01(pixelDist));

				Color pixelColor = new Color(pixelDist, pixelDist, pixelDist, 1f);
				tx2d.SetPixel(x, y, pixelColor);
			}
		}
		tx2d.Apply();
		return tx2d;
	}

	private Texture2D GenrateRings(){
		Texture2D tx2d = new Texture2D(TextureSize,TextureSize);
		Vector2 centerPixel;
		centerPixel = centerPosition * TextureSize;
		
		for(int x = 0; x < TextureSize; x++) {
			for(int y = 0; y < TextureSize; y++) {
				Vector2 cp= new Vector3(x, y);
				float pixelDist = Vector2.Distance(cp, centerPixel) / (TextureSize * 0.5f);
				
				pixelDist = Mathf.Abs(1 - Mathf.Clamp01(pixelDist));
				pixelDist = Mathf.Sin(pixelDist * 30) * pixelDist;
				
				Color pixelColor = new Color(pixelDist, pixelDist, pixelDist, 1f);
				tx2d.SetPixel(x, y, pixelColor);
			}
		}
		tx2d.Apply();
		return tx2d;
	}

	private Texture2D GenrateColorByDot(){
		Texture2D tx2d = new Texture2D(TextureSize,TextureSize);
		Vector2 centerPixel;
		centerPixel = centerPosition * TextureSize;
		
		for(int x = 0; x < TextureSize; x++) {
			for(int y = 0; y < TextureSize; y++) {
				Vector2 cp= new Vector3(x, y);
				Vector2 pd = centerPixel - cp;
				pd.Normalize();

				float rDirec = Vector2.Dot(pd,Vector2.right);
				float lDirec = Vector2.Dot(pd,-Vector2.right);
				float uDirec = Vector2.Dot(pd,Vector2.up);

				Color pixelColor = new Color(lDirec, rDirec,  uDirec, 1f);
				tx2d.SetPixel(x, y, pixelColor);
			}
		}
		tx2d.Apply();
		return tx2d;
	}

	private Texture2D GenrateColorByAngle(){
		Texture2D tx2d = new Texture2D(TextureSize,TextureSize);
		Vector2 centerPixel;
		centerPixel = centerPosition * TextureSize;
		
		for(int x = 0; x < TextureSize; x++) {
			for(int y = 0; y < TextureSize; y++) {
				Vector2 cp= new Vector3(x, y);
				Vector2 pd = centerPixel - cp;
				pd.Normalize();
				
				float rDirec = Vector2.Angle(pd,Vector2.right)/360f;
				float lDirec = Vector2.Angle(pd,-Vector2.right)/360f;
				float uDirec = Vector2.Angle(pd,Vector2.up)/360f;
				
				Color pixelColor = new Color(lDirec, rDirec,  uDirec, 1f);
				tx2d.SetPixel(x, y, pixelColor);
			}
		}
		tx2d.Apply();
		return tx2d;
	}

}