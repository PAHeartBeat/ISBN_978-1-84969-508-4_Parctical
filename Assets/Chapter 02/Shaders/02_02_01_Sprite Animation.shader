Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Sprite Animation" {
	Properties {
		_Color ("Color" , Color) = (0.5,0.5,0.5,1)
		_MainTex ("Main Texture (RGB)", 2D) = "white" {}
		
		_HCells ("Horizontal Cells", float) = 1
		
		_Speed ("Animation Speed", float) = 12
	}
	
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed4 _Color;
		sampler2D _MainTex;
		
		fixed _HCells;
		
		fixed _Speed;
		
		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float2 spriteUV = IN.uv_MainTex;
			
			fixed hUVPer = 1f / _HCells;
			
			
			fixed totalCell = _HCells;
			fixed hTimeVal = fmod(_Speed * _Time.y, totalCell);
			hTimeVal = ceil(hTimeVal);
			
			fixed xVal = spriteUV.x;
			xVal += hUVPer * hTimeVal  * totalCell;
			xVal *= hUVPer;
		
			spriteUV = float2(xVal, spriteUV.y);
		
			float4 c;
			c = tex2D(_MainTex, spriteUV);
			
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a * _Color.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
