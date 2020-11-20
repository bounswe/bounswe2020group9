from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view
from rest_framework.parsers import JSONParser
from product.models import Product
from product.serializers import ProductSerializer
# Create your views here.


def get_product(request):
    return HttpResponse("Hello World!")

@api_view(['GET', 'POST'])
def product_list(request):
    if request.method == "GET":
        products = Product.objects.all()
        serializer = ProductSerializer(products, many=True)
        return JsonResponse(serializer.data, safe=False)

    elif request.method == "POST":
        data = JSONParser().parse(request)
        serializer = ProductSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data, status=201)
        return  JsonResponse(serializer.errors, status=400)


@api_view(['GET', 'PUT', 'DELETE'])
def product_detail(request, pk):
    try:
        product = Product.objects.get(pk=pk)
    except Product.DoesNotExist:
        return HttpResponse(status=404)

    if request.method == "GET":
        serializer = ProductSerializer(product)
        return JsonResponse(serializer.data)

    elif request.method == "PUT":
        data = JSONParser().parse(request)
        serializer = ProductSerializer(product,data=data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data)
        return JsonResponse(serializer.errors, status=400)

    elif request.method == "DELETE":
        product.delete()
        return HttpResponse(status=204)