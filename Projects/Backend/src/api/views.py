from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.reverse import reverse


@api_view(['GET'])
def api_root(request, format=None):
    return Response({
        'user': reverse('user-list', request=request, format=format),
        'customer': reverse('customer-list', request=request, format=format),
        'vendor': reverse('vendor-list', request=request, format=format),
        'product': reverse('product-list', request=request, format=format),
        # 'location': reverse('location-list', request=request, format=format),
    })
