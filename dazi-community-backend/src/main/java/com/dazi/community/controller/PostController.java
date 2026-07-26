package com.dazi.community.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.common.result.Result;
import com.dazi.community.entity.dto.CreatePostRequest;
import com.dazi.community.entity.dto.TopPostRequest;
import com.dazi.community.entity.po.PostComment;
import com.dazi.community.entity.po.PostInfo;
import com.dazi.community.service.PostService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;

@RestController
@RequestMapping("/api/v1/post")
public class PostController {

    @Resource
    private PostService postService;

    @PostMapping("/create")
    public Result<PostInfo> createPost(HttpServletRequest request, @Valid @RequestBody CreatePostRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(postService.createPost(userId, req));
    }

    @GetMapping("/page")
    public Result<Page<PostInfo>> getPostPage(
            @RequestParam(required = false) Long communityId,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(postService.getPostPage(communityId, page, size));
    }

    @GetMapping("/public/page")
    public Result<Page<PostInfo>> getPublicPosts(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size) {
        return Result.success(postService.getPublicPosts(page, size));
    }

    @GetMapping("/detail/{id}")
    public Result<PostInfo> getDetail(@PathVariable Long id) {
        return Result.success(postService.getPostDetail(id));
    }

    @GetMapping("/my")
    public Result<Page<PostInfo>> getMyPosts(HttpServletRequest request,
                                              @RequestParam(defaultValue = "1") int page,
                                              @RequestParam(defaultValue = "10") int size) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(postService.getUserPosts(userId, page, size));
    }

    @PostMapping("/like/{postId}")
    public Result<Void> likePost(HttpServletRequest request, @PathVariable Long postId) {
        Long userId = (Long) request.getAttribute("userId");
        postService.likePost(userId, postId);
        return Result.success();
    }

    @PostMapping("/unlike/{postId}")
    public Result<Void> unlikePost(HttpServletRequest request, @PathVariable Long postId) {
        Long userId = (Long) request.getAttribute("userId");
        postService.unlikePost(userId, postId);
        return Result.success();
    }

    @PostMapping("/comment/{postId}")
    public Result<PostComment> addComment(HttpServletRequest request, @PathVariable Long postId,
                                           @RequestParam String content,
                                           @RequestParam(required = false) Long parentId) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(postService.addComment(userId, postId, content, parentId));
    }

    @GetMapping("/comments/{postId}")
    public Result<Page<PostComment>> getComments(@PathVariable Long postId,
                                                  @RequestParam(defaultValue = "1") int page,
                                                  @RequestParam(defaultValue = "10") int size) {
        return Result.success(postService.getComments(postId, page, size));
    }

    @DeleteMapping("/delete/{postId}")
    public Result<Void> deletePost(HttpServletRequest request, @PathVariable Long postId) {
        Long userId = (Long) request.getAttribute("userId");
        postService.deletePost(userId, postId);
        return Result.success();
    }

    @PostMapping("/top")
    public Result<PostInfo> topPost(HttpServletRequest request, @Valid @RequestBody TopPostRequest req) {
        Long userId = (Long) request.getAttribute("userId");
        return Result.success(postService.topPost(userId, req));
    }
}
