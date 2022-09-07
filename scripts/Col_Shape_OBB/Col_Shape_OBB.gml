function ColOBB(position, size, orientation) constructor {
    self.position = position;               // Vec3
    self.size = size;                       // Vec3
    self.orientation = orientation;         // mat4
    
    static CheckObject = function(object) {
        return object.shape.CheckOBB(self);
    };
    
    static CheckPoint = function(point) {
        var dir = point.position.Sub(self.position);
        
        var size_array = self.size.AsLinearArray();
        var orientation_array = self.orientation.AsVectorArray();
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            
            var dist = dir.Dot(axis);
            
            if (abs(dist) > abs(size_array[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckSphere = function(sphere) {
        var nearest = self.NearestPoint(sphere.position);
        var dist = nearest.DistanceTo(sphere.position);
        return dist <= sphere.radius;
    };
    
    static CheckAABB = function(aabb) {
        var axes = [
            new Vector3(1, 0, 0),
            new Vector3(0, 1, 0),
            new Vector3(0, 0, 1),
            
            self.orientation.x,
            self.orientation.y,
            self.orientation.z,
        ];
        
        for (var i = 0; i < 3; i++) {
            for (var j = 3; j < 6; j++) {
                array_push(axes, axes[i].Cross(axes[j]));
            }
        }
        
        for (var i = 0; i < 15; i++) {
            if (!col_overlap_axis(self, aabb, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckOBB = function(obb) {
        var axes = [
            obb.orientation.x,
            obb.orientation.y,
            obb.orientation.z,
            
            self.orientation.x,
            self.orientation.y,
            self.orientation.z,
        ];
        
        for (var i = 0; i < 3; i++) {
            for (var j = 3; j < 6; j++) {
                array_push(axes, axes[i].Cross(axes[j]));
            }
        }
        
        for (var i = 0; i < 15; i++) {
            if (!col_overlap_axis(self, obb, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckPlane = function(plane) {
        var plen = self.size.x * abs(plane.normal.Dot(self.orientation.x)) +
            self.size.y * abs(plane.normal.Dot(self.orientation.y)) +
            self.size.z * abs(plane.normal.Dot(self.orientation.z));
        
        var dist = plane.normal.Dot(self.position) - plane.distance;
        
        return abs(dist) < plen;
    };
    
    static CheckCapsule = function(capsule) {
        
    };
    
    static CheckTriangle = function(triangle) {
        var edges = [
            triangle.b.Sub(triangle.a),
            triangle.c.Sub(triangle.b),
            triangle.a.Sub(triangle.c),
        ];
        
        var axes = [
            self.orientation.x,
            self.orientation.y,
            self.orientation.z,
            
            triangle.GetNormal(),
        ];
        
        for (var i = 0; i < 3; i++) {
            for (var j = 0; j < 3; j++) {
                array_push(axes, axes[i].Cross(edges[j]));
            }
        }
        
        for (var i = 0; i < 13; i++) {
            if (!col_overlap_axis(self, triangle, axes[i])) {
                return false;
            }
        }
        
        return true;
    };
    
    static CheckMesh = function(mesh) {
        return mesh.CheckOBB(self);
    };
    
    static CheckRay = function(ray, hit_info) {
        
    };
    
    static CheckLine = function(line) {
        
    };
    
    static NearestPoint = function(vec3) {
        var result = self.position;
        var dir = vec3.Sub(self.position);
        
        var size_array = self.size.AsLinearArray();
        var orientation_array = self.orientation.AsVectorArray();
        
        for (var i = 0; i < 3; i++) {
            var axis = orientation_array[i];
            
            var dist = dir.Dot(axis);
            
            dist = clamp(dist, -size_array[i], size_array[i]);
            result = result.Add(axis.Mul(dist));
        }
        
        return result;
    };
    
    static GetInterval = function(axis) {
        var vertices = [
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Add(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Add(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Add(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
            self.position.Sub(self.orientation.x.Mul(self.size.x)).Sub(self.orientation.y.Mul(self.size.y)).Sub(self.orientation.z.Mul(self.size.z)),
        ];
        
        var imin = axis.Dot(vertices[0]);
        var imax = imin;
        
        for (var i = 1; i < 8; i++) {
            var dot = axis.Dot(vertices[i]);
            imin = min(imin, dot);
            imax = max(imax, dot);
        }
        
        return new ColInterval(imin, imax);
    };
}