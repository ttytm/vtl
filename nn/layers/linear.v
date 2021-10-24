module layers

import vtl
import vtl.autograd
import vtl.la
import vtl.stats

pub struct LinearGate<T> {
pub:
	input  &autograd.Variable<T>
	weight &autograd.Variable<T>
	bias   &autograd.Variable<T>
}

pub fn (g &LinearGate<T>) backward<T>(payload &Payload<T>) []&vtl.Tensor<T> {
	grad := payload.variable.grad
	mut result := [grad, grad, grad]

	if input.requires_grad {
		result[0] = la.matmul(grad, weight.value)
	}

	if weight.requires_grad {
		result[1] = la.matmul(grad.t(), input.value)
	}

	if bias.requires_grad {
		result[2] = stats.sum_with_axis(grad, axis: 0)
	}

	return result
}

pub fn (g &LinearGate<T>) cache<T>(mut result Variable<T>, args ...autograd.CacheParam) {
	input := args[0]
	weight := args[1]
	bias := args[1]

	if input is Variable<T> && weight is Variable<T> && bias is Variable<T> {
		result.grad = vtl.zeros_like<T>(result.value)
		result.requires_grad = true

		register<T>('Linear', g, result, input, weight, bias)
	}
}
