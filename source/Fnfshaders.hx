#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end
import flash.display.BitmapData;
import openfl.display.ShaderInput;
class Fnfshaders extends FlxRuntimeShader {

   /**
	 * Set or modify a sampler2D input of the shader.
	 * @param name The name of the shader input to modify.
	 * @param value The texture to use as the sampler2D input.
	 */
	public  function  setSampler2D(name:String, value:BitmapData)
        {
            var prop:ShaderInput<BitmapData> = Reflect.field(this.data, name);
            if(prop == null)
            {
                trace('[WARNING] Shader sampler2D property ${name} not found.');
                return;
            }
            prop.input = value;
        }
}