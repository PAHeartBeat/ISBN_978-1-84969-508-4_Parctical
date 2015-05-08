Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Specular (Blinn Phong)" {
	Properties {
		_Color ("Color", color) = (0.5,0.5,0.5)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		// Here we are just modifing one value for Unity Default Specular shader 
		// For Specular effect Unity use BlinnPhong Lighting model insted if Lambert Lighing model
		// Unity is using Lamber Model for diffse lighting effect

		CGPROGRAM
		#pragma surface surf BlinnPhong
		
		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Shininess;
		
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb ;
			o.Alpha = c.a;
			
			// For Specular shader we need to assing Specular value which are also know as Specular Power or specular hardness
			// We also need to assign Gloss value normly its came for texture's Alpha Chanel, this property
			// will decide on  intencity of specular on surface area
			
			// Here we customize that value to fix 1 so it will calculate with same intencity on whole surface.
			o.Gloss = 1;
			o.Specular = _Shininess;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
