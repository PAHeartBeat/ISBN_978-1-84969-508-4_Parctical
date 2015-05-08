Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Specular (Blinn Phong) - My Ref edition" { 
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

		// MyBlinnPhong is the same as Uniyt Default BlinnPhong but not add all lighing caluclation in this one
		// it's Add only for ref of how Unity BlinnPhong Works

		CGPROGRAM
		#pragma surface surf MyBlinnPhong
		
		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Shininess;
		
		struct Input {
			float2 uv_MainTex;
		};

		inline fixed4 LightingMyBlinnPhong (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half3 h = normalize (lightDir + viewDir);
			
			fixed diff = max (0, dot (s.Normal, lightDir));
			
			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, s.Specular * 128.0) * s.Gloss;
			
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 2);
			c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
			return c;
		}
		
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a  * _Color.a;
			
			// For Specular shader we need to assing Specular value which are also know as Specular Power or specular hardness
			// We also need to assign Gloss value normly its came for texture's Alpha Chanel, this property
			// will decide on  intencity of specular on surface area
			
			// Here we customize that value to fix 1 so it will calculate with same intencity on whole surface.
			o.Gloss = c.a;
			o.Specular = _Shininess;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
