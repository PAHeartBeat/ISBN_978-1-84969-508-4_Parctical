Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Normal Diffuse (Intencity)" {
	Properties {
		_Color ("Color" , Color) = (0.5,0.5,0.5,1)
		_NormalTex ("Normal Texure", 2D) = "bump" {}
		_NormalInte ("Normal Map Intencity",Range (0,2)) = 1
	}
	
	SubShader {
		Tags { "RenderType" = "Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _Color;
		fixed _NormalInte;
		sampler2D _NormalTex;
		
		struct Input {
			float2 uv_NormalTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float3 normals = UnpackNormal( tex2D(_NormalTex, IN.uv_NormalTex));
			normals  = float3(normals.xy * _NormalInte, normals.z);
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
			o.Normal = normals.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
