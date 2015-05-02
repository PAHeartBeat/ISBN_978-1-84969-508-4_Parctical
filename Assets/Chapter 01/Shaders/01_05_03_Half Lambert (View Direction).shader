Shader "PacktPub.com/Kenny Lammers/Cook Book Shaders/Half Lambert (View Direction)" {
	Properties {
		_EmissiveColor ("Emissive Color" , Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("This is a Slider", float) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf HalfLambertVD

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _MySliderValue;

		struct Input {
			float2 uv_MainTex;
		};
		
		inline float4 LightingHalfLambertVD(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten) {
			
			/*
			Diffuse light value is calculate by only one step when we using it for Half Lambert
			Step 1. Will get dot procduct (scalar) value of geomatry's normal and lighting direction
			*/
			float difLight = dot(s.Normal, lightDir);
			
			/*
			RIM light value is calculate by only one step when we using it for Half Lambert
			Step 1. Will get dot procduct (scalar) value of geomatry's normal and view direction of camera
			*/
			float rimLight = dot(s.Normal, viewDir);
			
			/*
			How to Half Lambert ?
			----------------------
			Half Lampbert Method is little differ from lambert
			Lambert Lighting will get dot procduct of normal and light from 0 to 1
			in Half Lambert it will get 0.5 to 1
			to acomlish tat task need to get first difuse light scaler and the multiply
			it with 0.5 it will get half of difuse so it's now 0 to 0.5 (as half lambert is 0.5 to 1)
			now add 0.5 so it will make 0.5 to 1
			
			Why Half Lambert
			----------------
			Valve Software intorduce it for half life game, because some geomatry are not faceing towards light of object.
			at that time that parictular area of geomatry will not effect of lighting and some time its looks pure flat color
			on that particular area. To over come that issue Valve Software has Develop "Half lambert" system when they
			are working on "Half Life" Game. (don't confuse and related it Half Life Game due to its developed time of 
			"Half Life" Game) it's Half Lambert system because it's calculate Diffuse Lighting from 0.5 to 1 insted of 
			0 to 1
			*/
			float hLambert = (difLight * 0.5) + 0.5;
			
			
			/*
			_LightColor0.rgb is value provide by unity which contains color of light
			atten is value also retrive from Unity which  intencity of light
			*/
			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb  * (hLambert * atten * 2 * rimLight);
			
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
