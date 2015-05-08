Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Specular Masking" { 

	Properties {
		_Color ("Color", color) = (0.5,0.5,0.5)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_SpecMask("Specular Texutre",2D) = "white" {}
		_Shininess ("Shininess", Range(0.01,1) ) = 0.078125
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		CGPROGRAM
		#pragma surface surf CustomPhong
		
		fixed4 _Color;
		sampler2D _MainTex;
		sampler2D _SpecMask;
		fixed _Shininess;
		
		struct CustomSurfaceOutput{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			
			fixed Alpha;
			fixed Gloss;
			half Specular;
			
			fixed3 CSpecColor;
		};
		
		struct Input {
			float2 uv_MainTex;
			float2 uv_SpecMask;
		};

	
		inline fixed4 LightingCustomPhong (CustomSurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			fixed diff = max(0, dot (s.Normal, lightDir));
			

			fixed3 halfDir = normalize(2 * diff * s.Normal - lightDir);
			
			fixed nh = max(0, dot(viewDir, halfDir));
			fixed spec = pow(nh, s.Specular * 128) * s.Gloss;
			
			fixed4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * diff ) + (spec * s.CSpecColor * _LightColor0.rgb));
			c.a = s.Alpha;
			return c;
		}
		
		void surf (Input IN, inout CustomSurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			half4 sMask = tex2D (_SpecMask, IN.uv_SpecMask) * _SpecColor;
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a  * _Color.a;
			
			// For Specular shader we need to assing Specular value which are also know as Specular Power or specular hardness
			// We also need to assign Gloss value normly its came for texture's Alpha Chanel, this property
			// will decide on  intencity of specular on surface area
			
			// Here we customize that value to fix 1 so it will calculate with same intencity on whole surface.
			o.Gloss = sMask.r;
			o.Specular =  _Shininess;
			o.CSpecColor = sMask.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
