Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Ramp Texture" {
	Properties {
		_RampTex ("Ramp Texture",2D) = "white" {}
		_EmissiveColor ("Emissive Color" , Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", float) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Ramp

		sampler2D _RampTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;

		struct Input {
			float2 uv_MainTex;
		};
		
		inline float4 LightingRamp (SurfaceOutput s, fixed3 lightDir, fixed atten) {

			/*
			Diffuse light value is calculate in two step when using it with "Lambert" Lighting model
			Step 1. Will get dot procduct (scalar) value of geomatry's normal and lighting direction
			Step 2. will get higher value from 0 and dot product calculated from 1st step.
			*/
			float difLight = max (0, dot(s.Normal, lightDir));
			
			/*
			To get Ramp info on Geomatry we need float2 / vector2 type to as UI of geomatry.
			In custom lighting mode we don't have access of Geomatry value like vertex / UV info, so normaly we can use 
			Lambert base diffuse Light or Half Lambert base diffuse light scalar to maniplate fake UI (as ramp texture effect 
			also fake light effect so we can use it)
			here I used difLight as UV of geomatry and unpack texture info and later we will multiply it with light color
			and Albedo value came form SurfaceOutput
						
			Here we not calculate Half Lambert Light so we will use it Lambert based Diffuse Light to get fake UV of Mesh
			*/
			float3 ramp = tex2D(_RampTex, float2(difLight)).rgb;
			
			/*
			_LightColor0.rgb is value provide by unity which contains color of light
			atten is value also retrive from Unity which  intencity of light
			*/
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb  * (ramp);
			
			col.a = s.Alpha;
			return col;
		}
		

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor) , _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
