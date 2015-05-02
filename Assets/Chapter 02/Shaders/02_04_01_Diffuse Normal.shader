Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Normal Diffuse" {
	Properties {
		_Color ("Color" , Color) = (0.5,0.5,0.5,1)
		_NormalTex ("Normal Texure", 2D) = "bump" {}
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _Color;
		sampler2D _NormalTex;
		
		struct Input {
			float2 uv_NormalTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float3 normals = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
			o.Normal = normals.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
