Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Nomral Half Lambert (Intencity)" {
	Properties {
		_Color ("Color" , Color) = (0.5,0.5,0.5,1)
		_NormalTex ("Normal Texure", 2D) = "bump" {}
		_NormalInte ("Normal Map Intencity",Range (0,2)) = 1
		
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf HalfLambert

		fixed4 _Color;
		sampler2D _NormalTex;
		fixed _NormalInte;
		
		struct Input {
			float2 uv_NormalTex;
		};
		
		inline float4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten) {
			float difLight = dot(s.Normal, lightDir);
			float hLambert = (difLight * 0.5) + 0.5;
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb  * (hLambert * atten * 2);
			
			col.a = s.Alpha;
			return col;
		}

		void surf (Input IN, inout SurfaceOutput o) {
		
			float3 normals = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			normals  = float3(normals.xy * _NormalInte, normals.z);
			
			o.Normal = normals.rgb;
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
