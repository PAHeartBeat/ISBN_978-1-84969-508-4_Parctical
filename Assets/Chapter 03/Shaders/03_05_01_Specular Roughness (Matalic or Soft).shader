Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Specular Roughness (Metalic or Soft)" { 

	Properties {
		_Color ("Color", color) = (0.5,0.5,0.5)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_MainTex ("Base (RGB) Gloss (A)", 2D) = "white" {}
		_RoughTex("Rough Texutre",2D) = "" {}
		_RoughPow("Roughness Power", float) = 0.5
		_Shininess ("Shininess", float ) = 2
		_Fresnel ("Fresnel", float) = 0.05

		//_RoughPow("Roughness Power", Range(0.999,0.01)) = 0.5
		//_Shininess ("Shininess", Range(0.01,30) ) = 0.078125
		//_Fresnel ("Fresnel", Range(0,1.0)) = 0.05
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		CGPROGRAM
		#pragma surface surf MetalicSoft
		#pragma target 3.0
		
		fixed4 _Color;
		sampler2D _MainTex;
		sampler2D _RoughTex;
		fixed _RoughPow;
		fixed _Shininess;
		fixed _Fresnel;
		
		struct Input {
			float2 uv_MainTex;
		};

	
		inline fixed4 LightingMetalicSoft (SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			float3 halfVector = normalize(lightDir + viewDir);
			float NdotL = saturate(dot(s.Normal, normalize(lightDir)));
			float NdotH_raw = dot(s.Normal, halfVector);
			float NdotH = saturate(dot(s.Normal, halfVector));
			float NdotV = saturate(dot(s.Normal, normalize(viewDir)));
			float VdotH = saturate(dot(halfVector, normalize(viewDir)));
			
			//Micro facets distribution
			float geoEnum = 2.0 * NdotH;
			float G1 = (geoEnum * NdotV)/NdotH;
			float G2 = (geoEnum * NdotL)/NdotH;
			float G =  min(1.0f, min(G1, G2));
			
			//Sample our Spceular look up BRDF
			float roughness = tex2D(_RoughTex, float2(NdotH_raw * 0.5 + 0.5, _RoughPow)).r;
			
			//Create our custom fresnel value
			float fresnel = pow(1.0-VdotH, 5.0);
			fresnel *= (1.0 - _Fresnel);
			fresnel += _Fresnel;
			
			//Create the final spec
			float spec = float(fresnel * G * roughness * roughness) * s.Specular;
			
			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL)+  (spec * _SpecColor.rgb) * (atten * 2.0f);
			c.a = s.Alpha;
			return c;
		}
		
		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a * _Color.a;
			
			o.Gloss = _Color.a;
			o.Specular = _Shininess;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
