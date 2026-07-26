package com.dazi.community.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.dazi.community.entity.dto.CreatePostRequest;
import com.dazi.community.entity.dto.TopPostRequest;
import com.dazi.community.entity.po.PostComment;
import com.dazi.community.entity.po.PostInfo;

public interface PostService {
    PostInfo createPost(Long userId, CreatePostRequest request);
    Page<PostInfo> getPostPage(Long communityId, int page, int size);
    PostInfo getPostDetail(Long id);
    void likePost(Long userId, Long postId);
    void unlikePost(Long userId, Long postId);
    PostComment addComment(Long userId, Long postId, String content, Long parentId);
    Page<PostComment> getComments(Long postId, int page, int size);
    void deletePost(Long userId, Long postId);
    Page<PostInfo> getUserPosts(Long userId, int page, int size);
    PostInfo topPost(Long userId, TopPostRequest request);
    Page<PostInfo> getPublicPosts(int page, int size);
}
